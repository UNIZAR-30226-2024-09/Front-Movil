import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aversifunciona/getUserSession.dart';

import 'PantallaCancion.dart';
import 'salas.dart';
import 'musica.dart';
import 'todo.dart';
import 'pantallaPodcast.dart';
import 'biblioteca.dart';
import 'buscar.dart';
import 'historial.dart';
import 'verPerfil.dart';
import 'configuracion.dart';
import 'cancion.dart';
import 'env.dart';
import 'reproductor.dart';
import 'cola.dart';

//List<dynamic> canciones = [];

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

/*class listaCanciones{
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


}*/

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
                          MaterialPageRoute(builder: (context) => Configuracion()),
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
/*void handleTap(BuildContext context, Cancion cancion) {
  // Aquí puedes manejar la acción de tap con la canción específica
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => reproductor(cancion: cancion, ids: [])), // cancion: cancion dentro de reproductor cuando esto funcione
  );
}*/

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

    bytes[0] = 10;
    bytes[1] = 20;
    bytes[2] = 30;
    bytes[3] = 40;

    return bytes;
  }
  String base64ToImageSrc(Uint8List bytes) {
    String base64String = base64Encode(bytes);
    return 'data:image/jpeg;base64,$base64String';
  }
  /*String base64ToImageSrc(String base64) {
    return 'data:image/jpeg;base64,${utf8.decode(base64Decode(base64.replaceAll(RegExp('/^data:image/[a-z]+;base64,/'), '')))}';
  }

  Future<void> conseguirCanciones() async {
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
  List<Map<String, dynamic>> cancionesRecomendadas = [];
  List<Map<String, dynamic>> podcastsRecomendados = [];
  List<Map<String, dynamic>> podcasts = [];
  List<Map<String, dynamic>> canciones = [];


  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _listarPodcasts();
    _listarCanciones();
    //_recomendar();

    //canciones = [1,2];
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
        _recomendar();
        print(_correoS);
      } else {
        print('Token is null');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> _recomendar() async {
    try {
      final Map<String, dynamic> data = {
        'correo': _correoS,
      };
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/recomendar/'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        // Recomendacion exitosa
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final Map<String, dynamic> recomendaciones = data['recomendaciones'];

        // Obtener lista de canciones recomendadas
        final List<dynamic>? cancionesData = recomendaciones['canciones'];
        final List<Map<String, dynamic>> cancionesRecomendadasAux = cancionesData?.map<Map<String, dynamic>>((cancionRecomendada) {
          return {
            'id': cancionRecomendada['id'] as int,
            'nombre': cancionRecomendada['nombre'] as String,
            'miAlbum': cancionRecomendada['miAlbum'] != null ? cancionRecomendada['miAlbum'] as int : null, // Verificar si miAlbum no es null
            'puntuacion': cancionRecomendada['puntuacion'] as int,
            //archivoMp3: cancionRecomendada['archivoMp3'] as String?,
            //'foto': cancionRecomendada['foto'] as String,
          };
        }).toList() ?? [];

// Obtener lista de podcasts recomendados
        final List<dynamic>? podcastsData = recomendaciones['podcasts'];
        final List<Map<String, dynamic>> podcastsRecomendadosAux = podcastsData?.map<Map<String, dynamic>>((podcastRecomendado) {
          return {
            'id': podcastRecomendado['id'] as int,
            'nombre': podcastRecomendado['nombre'] as String,
            //'foto': podcastRecomendado['foto'] as String,
          };
        }).toList() ?? [];


        // Actualizar el estado del widget con las recomendaciones
        setState(() {
          cancionesRecomendadas = cancionesRecomendadasAux;
          podcastsRecomendados = podcastsRecomendadosAux;
        });
      } else {
        throw Exception('Failed to get recommendation');
      }
    } catch (e) {
      print('Error en la función _recomendar: $e');
      // Manejar el error aquí
    }
  }

  Future<void> _listarPodcasts() async {
    final response = await http.post(
      Uri.parse('${Env.URL_PREFIX}/listarPocosPodcasts/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Recomendacion exitosa
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> podcastsData = data['podcasts'];

      // Obtener lista de podcasts
      final List<Map<String, dynamic>> podcastsAux = podcastsData.map((podcast) {
        return {
          'id': podcast['id'] as int,
          'nombre': podcast['nombre'] as String,
          //'foto': podcast['foto'] as String,
        };
      }).toList();

      // Limitar la lista de podcasts a solo 5 elementos
      final limitedPodcasts = podcastsAux.take(5).toList();

      // Actualizar el estado del widget con los podcasts limitados
      setState(() {
        podcasts = limitedPodcasts;
      });
    } else {
      throw Exception('Failed to get recommendation');
    }
  }

  Future<void> _listarCanciones() async {
    final response = await http.post(
      Uri.parse('${Env.URL_PREFIX}/listarPocasCanciones/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Recomendacion exitosa
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> cancionesData = data['canciones'];

      // Obtener lista de canciones
      final List<Map<String, dynamic>> cancionesAux = cancionesData.map((cancion) {
        return {
          'id': cancion['id'] as int,
          'nombre': cancion['nombre'] as String,
          //'foto': cancion['foto'] as String,
        };
      }).toList();

      // Limitar la lista de canciones a solo 5 elementos
      final limitedCanciones = cancionesAux.take(5).toList();

      // Actualizar el estado del widget con los podcasts limitados
      setState(() {
        canciones = limitedCanciones;
      });
    } else {
      throw Exception('Failed to get recommendation');
    }
  }

  Future<Uint8List> _fetchImageFromUrl(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      // Devuelve los bytes de la imagen
      return response.bodyBytes;
    } else {
      // Si la solicitud falla, lanza un error
      throw Exception('Failed to load image from $imageUrl');
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
              backgroundImage: AssetImage('lib/panda.jpg'),

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
                      // Mostrar canciones recomendadas
                      for (final cancionRecomendada in cancionesRecomendadas)
                        GestureDetector(
                          onTap: () {
                            if (cancionRecomendada['id'] != null) {
                              // Navegar a la pantalla de detalles de la canción
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PantallaCancion(songId: cancionRecomendada['id'])),
                              );
                            }
                          },
                          child: Container(
                            height: 150,
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: FutureBuilder<Uint8List>(
                                    future: _fetchImageFromUrl('${Env.URL_PREFIX}/imagenCancion/${cancionRecomendada['id']}'),
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
                                          snapshot.data!,
                                          height: 100, // Tamaño fijo para la imagen
                                          width: 100, // Tamaño fijo para la imagen
                                          fit: BoxFit.cover,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  cancionRecomendada['nombre'],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Mostrar podcasts recomendados
                      for (final podcastRecomendado in podcastsRecomendados)
                        GestureDetector(
                          onTap: () {
                            if (podcastRecomendado['id'] != null) {
                              // Navegar a la pantalla de detalles de la canción
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PantallaPodcast(podcastId: podcastRecomendado['id'], podcastName: podcastRecomendado['nombre']),
                                )
                              );
                            }
                          },
                          child: Container(
                            height: 150,
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: FutureBuilder<Uint8List>(
                                    future: _fetchImageFromUrl('${Env.URL_PREFIX}/imagenPodcast/${podcastRecomendado['id']}/'),
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
                                          snapshot.data!,
                                          height: 100, // Tamaño fijo para la imagen
                                          width: 100, // Tamaño fijo para la imagen
                                          fit: BoxFit.cover,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  podcastRecomendado['nombre'],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                const Text('Canciones', style: TextStyle(color: Colors.white),),
                const SizedBox(height: 8,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: 20,),
                      // Mostrar canciones
                      for (final cancion in canciones)
                        GestureDetector(
                          onTap: () {
                            if (cancion['id'] != null) {
                              // Navegar a la pantalla de detalles de la canción
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PantallaCancion(songId: cancion['id'])),
                              );
                            }
                          },
                          child: Container(
                            height: 150,
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: FutureBuilder<Uint8List>(
                                    future: _fetchImageFromUrl('${Env.URL_PREFIX}/imagenCancion/${cancion['id']}/'),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        // Muestra un indicador de carga mientras se carga la imagen
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        // Muestra un mensaje de error si ocurre un error durante la carga de la imagen
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        // Si la carga de la imagen fue exitosa, muestra la imagen
                                        return Image.memory(
                                          snapshot.data!,
                                          height: 100, // Tamaño fijo para la imagen
                                          width: 100, // Tamaño fijo para la imagen
                                          fit: BoxFit.cover,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  cancion['nombre'],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                const Text('Podcasts', style: TextStyle(color: Colors.white),),
                const SizedBox(height: 8,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: 20,),
                      // Mostrar podcasts
                      for (final podcast in podcasts)
                        GestureDetector(
                          onTap: () {
                            if (podcast['id'] != null) {
                              // Navegar a la pantalla de detalles de la canción
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PantallaPodcast(podcastId: podcast['id'], podcastName: podcast['nombre'])),
                              );
                            }
                          },
                          child: Container(
                            height: 150,
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: FutureBuilder<Uint8List>(
                                    future: _fetchImageFromUrl('${Env.URL_PREFIX}/imagenPodcast/${podcast['id']}/'),
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
                                          snapshot.data!,
                                          height: 100, // Tamaño fijo para la imagen
                                          width: 100, // Tamaño fijo para la imagen
                                          fit: BoxFit.cover,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  podcast['nombre'],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

              ],
            )
            ,
          )
      ),


      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 10), // Ajusta el valor según sea necesario para la posición deseada
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Cola()), // Suponiendo que Cola sea la pantalla a la que quieres navegar
            );
          },
          child: Icon(Icons.queue_music),
        ),
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