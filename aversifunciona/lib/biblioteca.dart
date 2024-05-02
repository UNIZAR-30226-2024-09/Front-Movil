import 'dart:convert';

import 'package:aversifunciona/cancionesFavoritas.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/salas.dart';
import 'package:flutter/material.dart';
import 'package:aversifunciona/getUserSession.dart';
import 'env.dart';
import 'historial.dart';
import 'verPerfil.dart';
import 'configuracion.dart';
import 'buscar.dart';
import 'playlist.dart';
import 'package:http/http.dart' as http;

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

class pantalla_biblioteca extends StatefulWidget {
  @override
  _pantalla_bibliotecaState createState() => _pantalla_bibliotecaState();
}

class _pantalla_bibliotecaState extends State<pantalla_biblioteca> {
  int playlistId = 31;
  String _correoS = '';
  List<String> _playlists = [];
  Map<String, int> _playlistsIds = {};

  @override
  void initState() {
    super.initState();
    _getUserInfo();
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
        _getUserPlaylists();
      } else {
        print('Token is null');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> _getUserPlaylists() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarPlaylistsUsuario/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'correo': _correoS}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Response: $responseData');
        if (responseData.containsKey('playlists') && responseData['playlists'] != null) {
          final List<dynamic> playlistData = responseData['playlists'];
          final List<String> playlists = [];
          final Map<String, int> playlistIds = {}; // Mapa para guardar IDs de playlists

          playlistData.forEach((data) {
            final nombre = data['nombre'].toString();
            final id = data['id'] as int;
            playlists.add(nombre);
            playlistIds[nombre] = id; // Asociar nombre de playlist con su ID
          });

          setState(() {
            _playlists = playlists;
            _playlistsIds = playlistIds; // Guardar el mapa de IDs de playlist
          });
        } else {
          print('No se encontraron listas de reproducción para este usuario.');
        }
      } else {
        print('Else: Error al obtener las playlists: ${response.statusCode}');
      }
    } catch (e) {
      print('Catch: Error fetching user playlists: $e');
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
          'Tu biblioteca',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
          actions: [
            TextButton(
              onPressed: () {
                // Aquí puedes definir la acción que deseas realizar cuando se presione el botón "+"
              },
              child: Text(
                '+',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ]
      ),
      body: Column(
        children: [
          // Sección 1

          Expanded(
            child: Container(
              child: ListView(
                children: [
                SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _playlists.length,
                      itemBuilder: (context, index) {
                        final playlistName = _playlists[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                final playlistId = _playlistsIds[playlistName];
                                if (playlistId != null) {
                                  return Playlist(playlistId: playlistId);
                                } else {
                                  // Manejar el caso en que el ID de la playlist sea nulo
                                  return Scaffold(
                                    body: Center(
                                      child: Text('No se encontró la playlist correspondiente.'),
                                    ),
                                  );
                                }
                              }),
                            );

                          },
                          child: ListTile(
                            title: Text(
                              playlistName,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ]
              ),

            ),
          ),
          Container(
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
                      MaterialPageRoute(
                          builder: (context) => pantalla_principal()),
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
                        Icon(Icons.house_outlined, color: Colors.grey, size: 37.0),
                        Text(
                          'Inicio',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ]
                  ),
                ),


                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => pantalla_buscar()),
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
                      ]
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => pantalla_biblioteca()),
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
                      ]
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => pantalla_salas()),
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
                      ]
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
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }

  Widget buildTopButton(String title) {
    return Container(
      margin: EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () {
          // Acción al presionar el botón (puedes personalizarlo según sea necesario)
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
