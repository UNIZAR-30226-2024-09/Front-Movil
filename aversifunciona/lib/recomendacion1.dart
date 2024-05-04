import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aversifunciona/recomendacion2.dart';

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
  List<String> artistas = [];
  List<String> generos = [
  ]; // Agregamos una lista para los géneros de canciones

  @override
  void initState() {
    super.initState();
    _fetchArtistas(); // Llamar a la función para obtener los artistas al inicializar la pantalla
    _fetchGeneros(); // Llamar a la función para obtener los géneros de canciones
  }

  Future<void> _fetchArtistas() async {
    final response = await http.get(Uri.parse('${Env.URL_PREFIX}/artistas/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> artistasData = data['artistas'];
      final List<String> artistasList = artistasData.map((
          artista) => artista['nombre'] as String).toList();
      setState(() {
        artistas = artistasList;
      });
    } else {
      throw Exception('Failed to load artistas');
    }
  }


  Future<void> _fetchGeneros() async {
    final response = await http.get(
        Uri.parse('${Env.URL_PREFIX}/generosCanciones/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> generosData = data['generos'];
      final List<String> generosList = generosData.map((
          genero) => genero['nombre'] as String).toList();
      setState(() {
        generos = generosList;
      });
    } else {
      throw Exception('Failed to load generos');
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20.0),
                  // Mostrar botones con las imágenes y nombres de los artistas
                  ...artistas.sublist(0, (artistas.length / 2).ceil()).map((artista) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              // Acción al presionar un artista
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => Recomendacion2(artista)),
                              // );
                            },
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/imagen_artista.jpg'), // Aquí debes colocar la ruta de tu imagen
                              radius: 20.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          ElevatedButton(
                            onPressed: () {
                              // Acción al presionar un artista
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => Recomendacion2(artista)),
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                            ),
                            child: Text(
                              artista,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20.0),
                  // Mostrar botones con las imágenes y nombres de los artistas
                  ...artistas.sublist((artistas.length / 2).ceil()).map((artista) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              // Acción al presionar un artista
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => Recomendacion2(artista)),
                              // );
                            },
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/imagen_artista.jpg'), // Aquí debes colocar la ruta de tu imagen
                              radius: 20.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          ElevatedButton(
                            onPressed: () {
                              // Acción al presionar un artista
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => Recomendacion2(artista)),
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                            ),
                            child: Text(
                              artista,
                              style: TextStyle(color: Colors.white),
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
            // Mostrar botones con los nombres de los géneros (primera fila)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20.0),
                  // Mostrar botones con los nombres de los géneros (primera fila)
                  ...generos.sublist(0, (generos.length / 2).ceil()).map((genero) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Acción al presionar un género
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => Recomendacion2(genero)),
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                        ),
                        child: Text(
                          genero,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            // Mostrar botones con los nombres de los géneros (segunda fila)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20.0),
                  // Mostrar botones con los nombres de los géneros (segunda fila)
                  ...generos.sublist((generos.length / 2).ceil()).map((genero) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Acción al presionar un género
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => Recomendacion2(genero)),
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                        ),
                        child: Text(
                          genero,
                          style: TextStyle(color: Colors.white),
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
    );
  }



}