import 'dart:convert';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/recomendacion2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aversifunciona/getUserSession.dart';
import 'env.dart';

void main() {
  runApp(Recomendacion1());
}

class Recomendacion1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Recomendacion1Screen(),
    );
  }
}

class Recomendacion1Screen extends StatefulWidget {
  @override
  _Recomendacion1ScreenState createState() => _Recomendacion1ScreenState();
}

class _Recomendacion1ScreenState extends State<Recomendacion1Screen> {
  String? artistaSeleccionado; // Variable para almacenar el artista seleccionado
  String? generoSeleccionado; // Variable para almacenar el género seleccionado
  List<Map<String, dynamic>> artistas = [];
  List<Map<String, dynamic>> generos = []; // Agregamos una lista para los géneros de canciones
  String _correoS = '';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _fetchArtistas(); // Llamar a la función para obtener los artistas al inicializar la pantalla
    _fetchGeneros(); // Llamar a la función para obtener los géneros de canciones
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

  Future<void> _fetchArtistas() async {
    final response = await http.get(Uri.parse('${Env.URL_PREFIX}/artistas/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> artistasData = data['artistas'];
      final List<Map<String, dynamic>> artistasList = artistasData.map((artista) {
        return {
          'id': artista['id'] as int, // Obtener el ID del artista
          'nombre': artista['nombre'] as String,
        };
      }).toList();
      setState(() {
        artistas = artistasList;
      });
    } else {
      throw Exception('Failed to load artistas');
    }
  }

  Future<void> _fetchGeneros() async {
    final response = await http.get(Uri.parse('${Env.URL_PREFIX}/generosCanciones/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> generosData = data['generos'];
      final List<Map<String, dynamic>> generosList = generosData.map((genero) {
        return {
          'nombre': genero['nombre'] as String,
        };
      }).toList();
      setState(() {
        generos = generosList;
      });
    } else {
      throw Exception('Failed to load generos');
    }
  }

  Future<void> _agnadirArtistaFavorito(String artistaId) async {
    //final String correo = 'sarah@gmail.com'; // Aquí debes obtener el correo del usuario
    final Map<String, dynamic> data = {
      'correo': _correoS,
      'artistaId': artistaId,
    };
    final response = await http.post(
      Uri.parse('${Env.URL_PREFIX}/agnadirArtistaFavorito/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      // Artista añadido exitosamente
    } else {
      throw Exception('Failed to add artista favorito');
    }
  }

  Future<void> _agnadirGeneroCancionFavorito(String generoCancion) async {
    //final String correo = "sarah@gmail.com"; // Aquí debes obtener el correo del usuario
    final Map<String, dynamic> data = {
      'correo': _correoS,
      'genero': generoCancion,
    };
    final response = await http.post(
      Uri.parse('${Env.URL_PREFIX}/agnadirGeneroFavorito/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      // Género cancion añadido exitosamente
    } else {
      throw Exception('Failed to add género cancion favorito');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '¿Qué prefieres?',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '¿Qué artista prefieres?',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10.0),
            // Primera fila de artistas
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20.0),
                  // Mostrar botones con las imágenes y nombres de los artistas (primera fila)
                  ...artistas.sublist(0, (artistas.length / 2).ceil()).map((artista) {
                    final bool seleccionado = artistaSeleccionado == artista['nombre'];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (seleccionado) {
                                  artistaSeleccionado = null; // Deseleccionar el artista actual
                                } else {
                                  artistaSeleccionado = artista['nombre']; // Seleccionar el nuevo artista
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage('${Env.URL_PREFIX}/imagenArtista/${artista['id']}/'), // Aquí debes colocar la ruta de tu imagen
                              radius: 20.0,
                              //backgroundColor: seleccionado ? Colors.white : null,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (seleccionado) {
                                  artistaSeleccionado = null; // Deseleccionar el artista actual
                                } else {
                                  artistaSeleccionado = artista['nombre']; // Seleccionar el nuevo artista
                                  _agnadirArtistaFavorito(artista['id'].toString());
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: seleccionado ? Colors.grey[800] : Colors.grey[300],
                            ),
                            child: Text(
                              artista['nombre'],
                              style: TextStyle(
                                color: seleccionado ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            // Segunda fila de artistas
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20.0),
                  // Mostrar botones con las imágenes y nombres de los artistas (segunda fila)
                  ...artistas.sublist((artistas.length / 2).ceil()).map((artista) {
                    final bool seleccionado = artistaSeleccionado == artista['nombre'];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (seleccionado) {
                                  artistaSeleccionado = null; // Deseleccionar el artista actual
                                } else {
                                  artistaSeleccionado = artista['nombre']; // Seleccionar el nuevo artista
                                  _agnadirArtistaFavorito(artista['id'].toString());
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage('${Env.URL_PREFIX}/imagenArtista/${artista['id']}/'), // Aquí debes colocar la ruta de tu imagen
                              radius: 20.0,
                              //backgroundColor: seleccionado ? Colors.white : null,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (seleccionado) {
                                  artistaSeleccionado = null; // Deseleccionar el artista actual
                                } else {
                                  artistaSeleccionado = artista['nombre']; // Seleccionar el nuevo artista
                                  _agnadirArtistaFavorito(artista['id'].toString());
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: seleccionado ? Colors.grey[800] : Colors.grey[300],
                            ),
                            child: Text(
                              artista['nombre'],
                              style: TextStyle(
                                color: seleccionado ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '¿Qué género de canciones prefieres?',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10.0),
            // Primera fila de géneros
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20.0),
                  // Mostrar botones con los nombres de los géneros (primera fila)
                  ...generos.sublist(0, (generos.length / 2).ceil()).map((generoCancion) {
                    final bool seleccionado = generoSeleccionado == generoCancion['nombre'];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (seleccionado) {
                              generoSeleccionado = null; // Deseleccionar el género actual
                            } else {
                              generoSeleccionado = generoCancion['nombre']; // Seleccionar el nuevo género
                              _agnadirGeneroCancionFavorito(generoSeleccionado.toString());
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: seleccionado ? Colors.grey[800] : Colors.grey[300],
                        ),
                        child: Text(
                          generoCancion['nombre'],
                          style: TextStyle(color: seleccionado ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            // Segunda fila de géneros
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20.0),
                  // Mostrar botones con los nombres de los géneros (segunda fila)
                  ...generos.sublist((generos.length / 2).ceil()).map((generoCancion) {
                    final bool seleccionado = generoSeleccionado == generoCancion['nombre'];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (seleccionado) {
                              generoSeleccionado = null; // Deseleccionar el género actual
                            } else {
                              generoSeleccionado = generoCancion['nombre']; // Seleccionar el nuevo género
                              _agnadirGeneroCancionFavorito(generoSeleccionado.toString());
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: seleccionado ? Colors.grey[800] : Colors.grey[300],
                        ),
                        child: Text(
                          generoCancion['nombre'],
                          style: TextStyle(color: seleccionado ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0), // Añade un espacio de 30 puntos a cada lado
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alinea los botones al principio y al final del Row
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pantalla_principal()),
                );
              },
              label: Text(
                'Saltar',
                style: TextStyle(color: Colors.black), // Cambia el color del texto a blanco
              ),
              backgroundColor: Colors.grey,
            ),
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Recomendacion2()),
                );
              },
              label: Text(
                'Siguiente',
                style: TextStyle(color: Colors.black), // Cambia el color del texto a blanco
              ),
              backgroundColor: Colors.grey,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}