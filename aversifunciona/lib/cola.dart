import 'dart:convert';
import 'dart:typed_data';

import 'package:aversifunciona/biblioteca.dart';
import 'package:aversifunciona/buscar.dart';
import 'package:aversifunciona/configuracion.dart';
import 'package:aversifunciona/desplegable.dart';
import 'package:aversifunciona/getUserSession.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/pantallaPodcast.dart';
import 'package:aversifunciona/reproductor.dart';
import 'package:aversifunciona/salas.dart';
import 'package:aversifunciona/verPerfil.dart';
import 'package:aversifunciona/todo.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'env.dart';
import 'historial.dart';

class Cola extends StatefulWidget {
  @override
  _ColaState createState() => _ColaState();
}

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

class _ColaState extends State<Cola> {
  String _correoS = '';
  List<dynamic> _cola = [];
  bool cargado = false;

  @override
  void initState() {
    super.initState();
    _getListarCola();
  }



  Future<void> _getListarCola() async {
    try {
      String? token = await getUserSession.getToken();
      if (token != null) {
        Map<String, dynamic> userInfo = await getUserSession.getUserInfo(token);
        setState(() {
          _correoS = userInfo['correo'];
        });
        final response = await http.post(
          Uri.parse('${Env.URL_PREFIX}/listarCola/'), // Reemplaza 'tu_url_de_la_api' por la URL correcta
          body: json.encode({'correo': _correoS}),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);

          if (responseData.containsKey('queue') && responseData['queue'] != null) {
            final List<dynamic> colaData = responseData['queue'];
            final List<String> cola = colaData.map((data) => data['nombre'].toString()).toList();

            setState(() {
              _cola = cola;
              cargado = true;
            });
          } else {
            print('No se encontraron canciones en la cola de este usuario.');
          }

          setState(() {
            _cola = responseData['queue'];
          });
        } else {
          throw Exception('Error al obtener la cola: ${response.statusCode}');
        }
      } else {
        throw Exception('Error al obtener la cola: ');
      }
    } catch (e) {
      print('Catch: $e');
    }
  }

  // Método para cargar una imagen desde una URL
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

  void _deleteSongFromQueue(int songId) async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/eliminarCancionCola/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': _correoS,
          'cancionId': songId,
        }),
      );
      if (response.statusCode == 200) {
        // Eliminación exitosa
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Canción eliminada de la cola'),
          ),
        );
        // Actualizar la lista de canciones después de eliminar la canción
        setState(() {
          _cola.removeWhere((song) => song['id'] == songId);
        });
      } else {
        throw Exception('Error al eliminar la canción de la playlist');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al eliminar la canción de la playlist'),
        ),
      );
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
          'Mi cola de reproducción',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.play_arrow, color: Colors.white),
                onPressed: () {
                  // Acción al presionar el botón de reproducción

                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: !cargado
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
              itemCount: _cola.length,
              itemBuilder: (context, index) {
                final cancion = _cola[index];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _deleteSongFromQueue(cancion['id']); // Eliminar la canción de la playlist
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  child: ListTile(
                    leading: FutureBuilder<Uint8List>(
                      future: _fetchImageFromUrl('${Env.URL_PREFIX}/imagenCancion/${cancion['id']}/'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const SizedBox(); // Devuelve un widget vacío mientras espera
                        } else if (snapshot.hasError) {
                          return const Icon(Icons.error);
                        } else {
                          return Image.memory(
                            snapshot.data!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          );
                        }
                      },
                    ),
                    title: Text(
                      cancion['nombre'] ?? '',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // Acción al seleccionar una canción del historial
                    },
                  ),
                );
              },
            ),
          ),

          Container(
            height: 70,
            decoration: BoxDecoration(
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
                    backgroundColor:Colors.transparent,
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
                    backgroundColor:Colors.transparent,
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
                    backgroundColor:Colors.transparent,
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
                    backgroundColor:Colors.transparent,
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
        ],
      ),
    );
  }

  Widget buildOption(String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Aquí puedes agregar tu propio widget de imagen si es necesario
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18), // Ajusta el tamaño de la fuente según sea necesario
        ),
      ],
    );
  }

  Widget buildTopButton(BuildContext context, String title, Widget screen) {
    return Container(
      margin: EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () {
          // Navegar a la pantalla correspondiente
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => reproductor()),
          );*/
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}




