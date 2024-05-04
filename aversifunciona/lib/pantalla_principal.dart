import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aversifunciona/getUserSession.dart';

import 'salas.dart';
import 'musica.dart';
import 'todo.dart';
import 'pantalla_podcast.dart';
import 'biblioteca.dart';
import 'buscar.dart';
import 'historial.dart';
import 'verPerfil.dart';
import 'configuracion.dart';
import 'cancion.dart';
import 'env.dart';
import 'reproductor.dart';

List<dynamic> canciones = [];

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        pantalla_opciones(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class listaCanciones{
  final List<dynamic> canciones;

  const listaCanciones({
    required this.canciones
  });

  factory listaCanciones.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'canciones': List<dynamic> id,


      } =>
          listaCanciones(
            canciones: id,

          ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }


}

class pantalla_opciones extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Row(children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: ListView(
                children: [
                  Container(
                    height: 125,
                    child: TextButton(
                      child: const Text(
                        'Ver perfil',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => verPerfil()),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 125,
                    child: TextButton(
                      child: const Text(
                        'Historial',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => historial()),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 125,
                    child: TextButton(
                      child: const Text(
                        'Configuración y privacidad',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => configuracion()),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Función de manejo de tap
void handleTap(BuildContext context, Cancion cancion) {
  // Aquí puedes manejar la acción de tap con la canción específica
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => reproductor(cancion: cancion,)), // cancion: cancion dentro de reproductor cuando esto funcione
  );
}

class pantalla_principal extends StatefulWidget {
  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<pantalla_principal> {

  Uint8List decodeBase64ToImage(String base64String) {
    /*try {
      return base64Decode(base64String);
    } catch (e) {
      throw Exception('Error decoding base64 string: $e');
    }*/
    Uint8List bytes = Uint8List(4);

    // Asignar valores a los elementos
    bytes[0] = 10;
    bytes[1] = 20;
    bytes[2] = 30;
    bytes[3] = 40;

    return bytes;
  }

  String base64ToImageSrc(String base64) {
    return 'data:image/jpeg;base64,${utf8.decode(base64Decode(base64.replaceAll(RegExp('/^data:image/[a-z]+;base64,/'), '')))}';
  }

  /*Future<void> conseguirCanciones() async {
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
          canciones.add(cancion);
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
  }*/


  String _correoS = '';

  @override
  void initState() {
    super.initState();
    _getUserInfo();

    canciones = [1,2];
    // Llama a la función para obtener canciones cuando la pantalla se inicia
    //conseguirCanciones();
  }

  Future<void> _getUserInfo() async {
    try {
      String? token = await getUserSession.getToken(); // Espera a que el token se resuelva
      print("Token: $token");
      if (token != null) {
        // Llama al método AuthService para obtener la información del usuario
        Map<String, dynamic> userInfo = await getUserSession.getUserInfo(token);
        setState(() {
          _correoS = userInfo['correo'];
        });
        print(_correoS);
      } else {
        print('Token is null');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: TextButton(
            child: const CircleAvatar(
              child: Icon(Icons.person_rounded, color: Colors.white,),
            ),
            onPressed: () {
              Navigator.of(context).push(_createRoute());
            }
        ),
        title: const Text(
          'Título de la pantalla',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          const Spacer(),
          buildTopButton(context, 'Todo', pantalla_todo()),
          buildTopButton(context, 'Música', pantalla_musica()),
          buildTopButton(context, 'Podcast', pantalla_podcast()),
        ],
      ),

      body: Center(

          child: canciones.isEmpty
              ? const CircularProgressIndicator() // Muestra el indicador de carga si canciones está vacío
              : SingleChildScrollView(

            child: Column(
              children: [

                const Text('Recomendado para ti', style: TextStyle(color: Colors.white),),
                const SizedBox(height: 8,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: 20,),
                      Container(height: 100, width: 100, padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Url.decode((base64ToImageSrc(canciones[0].foto)).split(',').last)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Muestra un indicador de carga mientras se decodifica la imagen
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              // Muestra un mensaje de error si ocurre un error durante la decodificación
                              return Text('Error: ${snapshot.error}', style: const TextStyle(fontSize: 6, color: Colors.black),);
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

                      Container(height: 100, width: 100, padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Url.decode((base64ToImageSrc(canciones[1].foto)).split(',').last)),
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
                      Container(height: 100, width: 100, padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Url.decode((base64ToImageSrc(canciones[2].foto)).split(',').last)),
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
                        Container(height: 100, width: 100, padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: FutureBuilder<Uint8List>(
                            future: Future.microtask(() => base64Url.decode((base64ToImageSrc(canciones[0].foto)).split(',').last)),
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

                        Container(height: 100, width: 100, padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: FutureBuilder<Uint8List>(
                            future: Future.microtask(() => base64Url.decode((base64ToImageSrc(canciones[1].foto)).split(',').last)),
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
                        Container(height: 100, width: 100, padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: FutureBuilder<Uint8List>(
                            future: Future.microtask(() => base64Url.decode((base64ToImageSrc(canciones[2].foto)).split(',').last)),
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
                      Container(height: 100, width: 100, padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Url.decode((base64ToImageSrc(canciones[0].foto)).split(',').last)),
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

                      Container(height: 100, width: 100, padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Url.decode((base64ToImageSrc(canciones[1].foto)).split(',').last)),
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
                      Container(height: 100, width: 100, padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Url.decode((base64ToImageSrc(canciones[2].foto)).split(',').last)),
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
                      Container(height: 100, width: 100, padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Url.decode((base64ToImageSrc(canciones[0].foto)).split(',').last)),
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

                      Container(height: 100, width: 100, padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Url.decode((base64ToImageSrc(canciones[1].foto)).split(',').last)),
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
                      Container(height: 100, width: 100, padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: FutureBuilder<Uint8List>(
                          future: Future.microtask(() => base64Url.decode((base64ToImageSrc(canciones[2].foto)).split(',').last)),
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


      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.white),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
              child: const Column(
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
              child: const Column(
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
              child: const Column(
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
              child: const Column(
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



  Widget buildOption(String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }

  Widget buildTopButton(BuildContext context, String title, Widget screen) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}