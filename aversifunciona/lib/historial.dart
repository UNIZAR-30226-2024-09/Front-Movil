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

import 'cola.dart';
import 'env.dart';

class historial extends StatefulWidget {
  @override
  _historialState createState() => _historialState();
}

class _historialState extends State<historial> {
  String _correoS = '';
  List<dynamic> _historial = [];

  @override
  void initState() {
    super.initState();
    _getListarHistorial();
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

  Future<void> _getListarHistorial() async {
    try {
      String? token = await getUserSession.getToken();
      if (token != null) {
        Map<String, dynamic> userInfo = await getUserSession.getUserInfo(token);
        setState(() {
          _correoS = userInfo['correo'];
        });
        final response = await http.post(
          Uri.parse('${Env.URL_PREFIX}/listarHistorial/'), // Reemplaza 'tu_url_de_la_api' por la URL correcta
          body: json.encode({'correo': _correoS}),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);

          if (responseData.containsKey('historial') && responseData['historial'] != null) {
            final List<dynamic> historialData = responseData['historial'];
            final List<String> historial = historialData.map((data) => data['nombre'].toString()).toList();

            setState(() {
              _historial = historial;
            });
          } else {
            print('No se encontraron listas de reproducción para este usuario.');
          }

          setState(() {
            _historial = responseData['historial'];
          });
        } else {
          throw Exception('Error al obtener el historial: ${response.statusCode}');
        }
      } else {
        throw Exception('Error al obtener el historial: ');
      }
    } catch (e) {
      print('Catch: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Mi historial',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _historial.length,
              itemBuilder: (context, index) {
                final cancion = _historial[index];
                return   ListTile(
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
                );
              },
            ),
          ),
        ], ),
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




