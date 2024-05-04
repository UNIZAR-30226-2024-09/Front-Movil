import 'dart:convert';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aversifunciona/getUserSession.dart';
import 'env.dart';

void main() {
  runApp(Recomendacion2());
}


class Recomendacion2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Recomendacion2Screen(),
    );
  }
}

class Recomendacion2Screen extends StatefulWidget {
  @override
  _Recomendacion2ScreenState createState() => _Recomendacion2ScreenState();
}

class _Recomendacion2ScreenState extends State<Recomendacion2Screen> {
  List<Map<String, dynamic>> presentadores = [];
  List<Map<String, dynamic>> generos = []; // Agregamos una lista para los géneros de podcasts
  String? presentadorSeleccionado; // Variable para almacenar el presentador seleccionado
  String? generoSeleccionado; // Variable para almacenar el género seleccionado
  String _correoS = '';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _fetchPresentadores(); // Llamar a la función para obtener los presentadores al inicializar la pantalla
    _fetchGeneros(); // Llamar a la función para obtener los géneros de podcasts
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

  Future<void> _fetchPresentadores() async {
    final response = await http.get(Uri.parse('${Env.URL_PREFIX}/presentadores/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> presentadoresData = data['presentadores'];
      final List<Map<String, dynamic>> presentadoresList = presentadoresData.map((presentador) {
        return {
          'id': presentador['id'] as int, // Obtener el ID del presentador
          'nombre': presentador['nombre'] as String,
        };
      }).toList();
      setState(() {
        presentadores = presentadoresList;
      });
    } else {
      throw Exception('Failed to load presentadores');
    }
  }

  Future<void> _fetchGeneros() async {
    final response = await http.get(Uri.parse('${Env.URL_PREFIX}/generosPodcasts/'));
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

  Future<void> _agnadirPresentadorFavorito(String presentadorId) async {
    //final String correo = ''; // Aquí debes obtener el correo del usuario
    final Map<String, dynamic> data = {
      'correo': _correoS,
      'presentadorId': presentadorId,
    };
    final response = await http.post(
      Uri.parse('${Env.URL_PREFIX}/agnadirPresentadorFavorito/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      // Presentador añadido exitosamente
    } else {
      throw Exception('Failed to add presentador favorito');
    }
  }

  Future<void> _agnadirGeneroPodcastFavorito(String generoPodcast) async {
    //final String correo = ''; // Aquí debes obtener el correo del usuario
    final Map<String, dynamic> data = {
      'correo': _correoS,
      'genero': generoPodcast,
    };
    final response = await http.post(
      Uri.parse('${Env.URL_PREFIX}/agnadirGeneroFavorito/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      // Género podcast añadido exitosamente
    } else {
      throw Exception('Failed to add género podcast favorito');
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
                '¿Qué presentador prefieres?',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10.0),
            // Primera fila de presentadores
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20.0),
                  // Mostrar botones con las imágenes y nombres de los presentadores (primera fila)
                  ...presentadores.sublist(0, (presentadores.length / 2).ceil()).map((presentador) {
                    final bool seleccionado = presentadorSeleccionado == presentador['nombre'];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (seleccionado) {
                                  presentadorSeleccionado = null; // Deseleccionar el presentador actual
                                } else {
                                  presentadorSeleccionado = presentador['nombre']; // Seleccionar el nuevo presentador
                                  _agnadirPresentadorFavorito(presentador['id'].toString());
                                }
                              });
                            },
                            child: CircleAvatar(
                              //backgroundImage: AssetImage('assets/imagen_presentador.jpg'), // Aquí debes colocar la ruta de tu imagen
                              radius: 20.0,
                              backgroundColor: seleccionado ? Colors.white : null,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (seleccionado) {
                                  presentadorSeleccionado = null; // Deseleccionar el presentador actual
                                } else {
                                  presentadorSeleccionado = presentador['nombre']; // Seleccionar el nuevo presentador
                                  _agnadirPresentadorFavorito(presentador['id'].toString());
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: seleccionado ? Colors.grey[800] : Colors.grey[300],
                            ),
                            child: Text(
                              presentador['nombre'],
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
            // Segunda fila de presentadores
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20.0),
                  // Mostrar botones con las imágenes y nombres de los presentadores (segunda fila)
                  ...presentadores.sublist((presentadores.length / 2).ceil()).map((presentador) {
                    final bool seleccionado = presentadorSeleccionado == presentador['nombre'];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (seleccionado) {
                                  presentadorSeleccionado = null; // Deseleccionar el presentador actual
                                } else {
                                  presentadorSeleccionado = presentador['nombre']; // Seleccionar el nuevo presentador
                                  _agnadirPresentadorFavorito(presentador['id'].toString());
                                }
                              });
                            },
                            child: CircleAvatar(
                              //backgroundImage: AssetImage('assets/imagen_presentador.jpg'), // Aquí debes colocar la ruta de tu imagen
                              radius: 20.0,
                              backgroundColor: seleccionado ? Colors.white : null,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (seleccionado) {
                                  presentadorSeleccionado = null; // Deseleccionar el presentador actual
                                } else {
                                  presentadorSeleccionado = presentador['nombre']; // Seleccionar el nuevo presentador
                                  _agnadirPresentadorFavorito(presentador['id'].toString());
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: seleccionado ? Colors.grey[800] : Colors.grey[300],
                            ),
                            child: Text(
                              presentador['nombre'],
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
                '¿Qué género de podcasts prefieres?',
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
                  ...generos.sublist(0, (generos.length / 2).ceil()).map((generoPodcast) {
                    final bool seleccionado = generoSeleccionado == generoPodcast['nombre'];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (seleccionado) {
                              generoSeleccionado = null; // Deseleccionar el género actual
                            } else {
                              generoSeleccionado = generoPodcast['nombre']; // Seleccionar el nuevo género
                              _agnadirGeneroPodcastFavorito(generoSeleccionado.toString());
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: seleccionado ? Colors.grey[800] : Colors.grey[300],
                        ),
                        child: Text(
                          generoPodcast['nombre'],
                          style: TextStyle(color: seleccionado ? Colors.white : Colors.black),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            // Segunda fila de géneros
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20.0),
                  // Mostrar botones con los nombres de los géneros (segunda fila)
                  ...generos.sublist((generos.length / 2).ceil()).map((generoPodcast) {
                    final bool seleccionado = generoSeleccionado == generoPodcast['nombre'];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (seleccionado) {
                              generoSeleccionado = null; // Deseleccionar el género actual
                            } else {
                              generoSeleccionado = generoPodcast['nombre']; // Seleccionar el nuevo género
                              _agnadirGeneroPodcastFavorito(generoSeleccionado.toString());
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: seleccionado ? Colors.grey[800] : Colors.grey[300],
                        ),
                        child: Text(
                          generoPodcast['nombre'],
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
                  MaterialPageRoute(builder: (context) => pantalla_principal()),
                );
              },
              label: Text(
                'Terminar',
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