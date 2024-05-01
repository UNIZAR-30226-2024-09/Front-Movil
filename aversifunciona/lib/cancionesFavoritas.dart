import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:aversifunciona/getUserSession.dart';
import 'package:aversifunciona/reproductor.dart';
import 'package:flutter/material.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/salas.dart';
import 'biblioteca.dart';
import 'buscar.dart';
import 'cancion.dart';
import 'package:http/http.dart' as http;
import 'env.dart';


class cancionesFavoritas extends StatefulWidget {
  @override
  _CancionesFavoritasState createState() => _CancionesFavoritasState();
}

class _CancionesFavoritasState extends State<cancionesFavoritas> {
  List<Cancion> canciones = []; // Lista para almacenar las canciones
  Cancion? selectedSong; // Canción seleccionada
  Map<String, dynamic> usuarioActual = {};

  bool isPlaying = false;
  double progress = 0.0; // Representa la posición de reproducción de la canción
  Timer? timer;

  @override
  void initState() {
    final token;
    super.initState();
    // Llama a la función para obtener canciones cuando la pantalla se inicia
    usuarioActual = getUserSession.getUserInfo(getUserSession.getToken() as String) as Map<String, dynamic>;
    conseguirCancionesFavoritas();
  }
  Uint8List decodeBase64ToImage(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      throw Exception('Error decoding base64 string: $e');
    }
  }

  String base64ToImageSrc(String base64) {
    return base64.replaceAll(RegExp('/^data:image/[a-z]+;base64,/'), '');
  }

  Future<void> conseguirCancionesFavoritas() async {
    try {
      final response = await http
          .post(Uri.parse("${Env.URL_PREFIX}/listarCanciones/"),
          headers: <String, String>{
            'Content-Type': 'application/json'
          },
          body: jsonEncode({})
      );
      canciones = [];

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        var lista = jsonDecode(response.body);
        var listaCanciones = lista['canciones'];

        for (var i = 0; i < 3 && i < listaCanciones.length; i++) {
          Cancion cancion = Cancion.fromJson(listaCanciones[i]);
          bool esFavorita = await verificarFavorita(cancion.id);
          if (esFavorita) {
            canciones.add(cancion);
          }
        }

        setState(() {});
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    }
    catch(e){
      print("Error: $e");
    }
  }

  Future<bool> verificarFavorita(int? cancionId) async {
    try {
      String? token = await getUserSession
          .getToken(); // Espera a que el token se resuelva
      //if (token != null) {
        Map<String, dynamic> userInfo = await getUserSession.getUserInfo(token!);
        final response = await http.post(
          Uri.parse("${Env.URL_PREFIX}/EsFavorita/"),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode({
            'correo': userInfo['correo'],
            'cancionId': cancionId.toString(),
          }),


        );


        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          return responseData['message'] == 'La canción está en favoritos';
        } else {
          throw Exception('Failed to verify favorite song');
        }

      } catch (e) {
      print("Error: $e");
      return false;
    }

  }




  void togglePlay() {
    setState(() {
      isPlaying = !isPlaying;
      // Simulamos el progreso de la canción
      if (isPlaying) {
        startPlaying();
      } else {
        stopPlaying();
      }
    });
  }

  void startPlaying() {
    // Cancelar el temporizador anterior si existe
    timer?.cancel();
    // Aquí podrías iniciar la reproducción de la canción
    // Por ahora solo actualizamos el progreso de forma simulada
    const progressIncrement = 0.01;
    const duration = Duration(seconds: 1);
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        if (progress >= 1.0) {
          progress = 0.0;
          stopPlaying();
        } else {
          progress += progressIncrement;
        }
      });
    });
  }

  void stopPlaying() {
    // Detener el temporizador si existe
    timer?.cancel();
    isPlaying = false;
  }

  void nextSong() {
    // Aquí iría la lógica para avanzar a la siguiente canción
  }

  void previousSong() {
    // Aquí iría la lógica para volver a la canción anterior
  }

  void replaySong() {
    setState(() {
      progress = 0.0;
      startPlaying();
      isPlaying = true;
    });
  }

  @override
  void dispose() {
    // Asegurarse de cancelar el temporizador cuando se desmonta el widget
    timer?.cancel();
    super.dispose();
  }

  void goToReproductor() {
    // Aquí iría la lógica para dirigirse a la pantalla del reproductor
    // junto con los datos de la canción para seguir reproduciendo
    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => reproductor(cancion: selectedSong),
      ),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(

          child: canciones.isEmpty
              ? const CircularProgressIndicator() // Muestra el indicador de carga si canciones está vacío
              : SingleChildScrollView(

            child: Column(
              children: [

                const Text('Texto numero 1', style: TextStyle(color: Colors.white),),
                const SizedBox(height: 8,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: 20,),
                      Container(height: 75, width: 75, padding: const EdgeInsets.symmetric(horizontal: 8), decoration: const BoxDecoration(color: Colors.grey),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Decode(canciones[0].foto)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Muestra un indicador de carga mientras se decodifica la imagen
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Muestra un mensaje de error si ocurre un error durante la decodificación
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Si la decodificación fue exitosa, muestra la imagen
                              return Image.memory(
                                height: 75,
                                width: 75,
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),

                      const SizedBox(width: 50,),

                      Container(height: 75, width: 75, padding: const EdgeInsets.symmetric(horizontal: 8), decoration: const BoxDecoration(color: Colors.grey),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Decode(canciones[1].foto)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Muestra un indicador de carga mientras se decodifica la imagen
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Muestra un mensaje de error si ocurre un error durante la decodificación
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Si la decodificación fue exitosa, muestra la imagen
                              return Image.memory(
                                height: 75,
                                width: 75,
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),

                      const SizedBox(width: 50,),
                      Container(height: 75, width: 75, padding: const EdgeInsets.symmetric(horizontal: 8), decoration: const BoxDecoration(color: Colors.grey),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Decode(canciones[2].foto)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Muestra un indicador de carga mientras se decodifica la imagen
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Muestra un mensaje de error si ocurre un error durante la decodificación
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Si la decodificación fue exitosa, muestra la imagen
                              return Image.memory(
                                height: 75,
                                width: 75,
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 50,),
                    ],
                  ),
                ),

                const SizedBox(height: 20,),
                const Text('Texto numero 2', style:  TextStyle(color: Colors.white),),
                const SizedBox(height: 8,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: 20,),
                      Container(height: 75, width: 75, padding: const EdgeInsets.symmetric(horizontal: 8), decoration: const BoxDecoration(color: Colors.grey),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Decode(canciones[0].foto)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Muestra un indicador de carga mientras se decodifica la imagen
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Muestra un mensaje de error si ocurre un error durante la decodificación
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Si la decodificación fue exitosa, muestra la imagen
                              return Image.memory(
                                height: 75,
                                width: 75,
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),

                      const SizedBox(width: 50,),

                      Container(height: 75, width: 75, padding: const EdgeInsets.symmetric(horizontal: 8), decoration: const BoxDecoration(color: Colors.grey),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Decode(canciones[1].foto)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Muestra un indicador de carga mientras se decodifica la imagen
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Muestra un mensaje de error si ocurre un error durante la decodificación
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Si la decodificación fue exitosa, muestra la imagen
                              return Image.memory(
                                height: 75,
                                width: 75,
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),

                      const SizedBox(width: 50,),
                      Container(height: 75, width: 75, padding: const EdgeInsets.symmetric(horizontal: 8), decoration: const BoxDecoration(color: Colors.grey),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Decode(canciones[2].foto)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Muestra un indicador de carga mientras se decodifica la imagen
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Muestra un mensaje de error si ocurre un error durante la decodificación
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Si la decodificación fue exitosa, muestra la imagen
                              return Image.memory(
                                height: 75,
                                width: 75,
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 50,),
                    ],
                  ),
                ),

                const SizedBox(height: 20,),
                const Text('Texto numero 3', style: TextStyle(color: Colors.white),),
                const SizedBox(height: 8,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: 20,),
                      Container(height: 75, width: 75, padding: const EdgeInsets.symmetric(horizontal: 8), decoration: const BoxDecoration(color: Colors.grey),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Decode(canciones[0].foto)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Muestra un indicador de carga mientras se decodifica la imagen
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Muestra un mensaje de error si ocurre un error durante la decodificación
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Si la decodificación fue exitosa, muestra la imagen
                              return Image.memory(
                                height: 75,
                                width: 75,
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),

                      const SizedBox(width: 50,),

                      Container(height: 75, width: 75, padding: const EdgeInsets.symmetric(horizontal: 8), decoration: const BoxDecoration(color: Colors.grey),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Decode(canciones[1].foto)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Muestra un indicador de carga mientras se decodifica la imagen
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Muestra un mensaje de error si ocurre un error durante la decodificación
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Si la decodificación fue exitosa, muestra la imagen
                              return Image.memory(
                                height: 75,
                                width: 75,
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),

                      const SizedBox(width: 50,),
                      Container(height: 75, width: 75, padding: const EdgeInsets.symmetric(horizontal: 8), decoration: const BoxDecoration(color: Colors.grey),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Decode(canciones[2].foto)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Muestra un indicador de carga mientras se decodifica la imagen
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Muestra un mensaje de error si ocurre un error durante la decodificación
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Si la decodificación fue exitosa, muestra la imagen
                              return Image.memory(
                                height: 75,
                                width: 75,
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 50,),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                const Text('Texto numero 4', style: TextStyle(color: Colors.white),),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: 20,),
                      Container(height: 75, width: 75, padding: const EdgeInsets.symmetric(horizontal: 8), decoration: const BoxDecoration(color: Colors.grey),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Decode(canciones[0].foto)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Muestra un indicador de carga mientras se decodifica la imagen
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Muestra un mensaje de error si ocurre un error durante la decodificación
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Si la decodificación fue exitosa, muestra la imagen
                              return Image.memory(
                                height: 75,
                                width: 75,
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),

                      const SizedBox(width: 50,),

                      Container(height: 75, width: 75, padding: const EdgeInsets.symmetric(horizontal: 8), decoration: const BoxDecoration(color: Colors.grey),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Decode(canciones[1].foto)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Muestra un indicador de carga mientras se decodifica la imagen
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Muestra un mensaje de error si ocurre un error durante la decodificación
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Si la decodificación fue exitosa, muestra la imagen
                              return Image.memory(
                                height: 75,
                                width: 75,
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),

                      const SizedBox(width: 50,),
                      Container(height: 75, width: 75, padding: const EdgeInsets.symmetric(horizontal: 8), decoration: const BoxDecoration(color: Colors.grey),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Decode(canciones[2].foto)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Muestra un indicador de carga mientras se decodifica la imagen
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Muestra un mensaje de error si ocurre un error durante la decodificación
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Si la decodificación fue exitosa, muestra la imagen
                              return Image.memory(
                                height: 75,
                                width: 75,
                                snapshot.data!,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 50,),
                    ],
                  ),
                ),
                const SizedBox(height: 8,),

              ],
            )
            ,
          )
      ),
      bottomNavigationBar: selectedSong != null
          ? Container(
        height: 150,
        color: Colors.grey[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Contenedor para la imagen y el nombre de la canción
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  // Imagen de la canción

                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey, // Puedes ajustar el color del cuadrado
                      borderRadius: BorderRadius.circular(8),

                    ),
                    child: Image.asset('ruta_de_la_imagen_cuadrado'), //imagen de la cancion
                  ),
                  SizedBox(width: 10),
                  // Nombre de la canción
                  /*Text(
                    selectedSong.nombre,
                    style: TextStyle(color: Colors.white),
                  ),*/
                ],
              ),
            ),
            // Iconos de reproducción y barra de progreso
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Iconos de reproducción
                Row(
                  children: [
                    IconButton(
                      onPressed: previousSong,
                      icon: Icon(Icons.skip_previous, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: togglePlay,
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: nextSong,
                      icon: Icon(Icons.skip_next, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: replaySong,
                      icon: Icon(Icons.replay, color: Colors.white),
                    ),
                  ],
                ),
                // Barra de progreso
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Slider(
                        value: progress,
                        onChanged: (newValue) {
                          setState(() {
                            progress = newValue;
                          });
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )
          : Container(
        height: 70,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.white),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Botones de navegación
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pantalla_principal()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 8),
                  Icon(Icons.house_outlined, color: Colors.grey, size: 37.0),
                  Text(
                    'Inicio',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pantalla_buscar()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 8),
                  Icon(Icons.question_mark_outlined, color: Colors.grey, size: 37.0),
                  Text(
                    'Buscar',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pantalla_biblioteca()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 8),
                  Icon(Icons.library_books_rounded, color: Colors.grey, size: 37.0),
                  Text(
                    'Biblioteca',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pantalla_salas()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 8),
                  Icon(Icons.chat_bubble_rounded, color: Colors.grey, size: 37.0),
                  Text(
                    'Salas',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


