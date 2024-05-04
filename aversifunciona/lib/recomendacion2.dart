import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  List<String> presentadores = [];
  List<String> generos = [
  ]; // Agregamos una lista para los géneros de podcasts

  @override
  void initState() {
    super.initState();
    _fetchPresentadores(); // Llamar a la función para obtener los presentadores al inicializar la pantalla
    _fetchGeneros(); // Llamar a la función para obtener los géneros de podcasts
  }

  Future<void> _fetchPresentadores() async {
    final response = await http.get(Uri.parse('${Env.URL_PREFIX}/presentadores/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> presentadoresData = data['presentadores'];
      final List<String> presentadoresList = presentadoresData.map((
          presentador) => presentador['nombre'] as String).toList();
      setState(() {
        presentadores = presentadoresList;
      });
    } else {
      throw Exception('Failed to load presentadores');
    }
  }


  Future<void> _fetchGeneros() async {
    final response = await http.get(
        Uri.parse('${Env.URL_PREFIX}/generosPodcasts/'));
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
                '¿Qué presentador prefieres?',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 20.0),
                  // Mostrar botones con las imágenes y nombres de los presentadores
                  ...presentadores.sublist(0, (presentadores.length / 2).ceil()).map((presentador) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              // Acción al presionar un presentador
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => Recomendacion2(presentador)),
                              // );
                            },
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/imagen_presentador.jpg'), // Aquí debes colocar la ruta de tu imagen
                              radius: 20.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          ElevatedButton(
                            onPressed: () {
                              // Acción al presionar un presentador
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => Recomendacion2(presentador)),
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                            ),
                            child: Text(
                              presentador,
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
                  // Mostrar botones con las imágenes y nombres de los presentadores
                  ...presentadores.sublist((presentadores.length / 2).ceil()).map((presentador) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              // Acción al presionar un presentador
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => Recomendacion2(presentador)),
                              // );
                            },
                            child: CircleAvatar(
                              backgroundImage: AssetImage('assets/imagen_presentador.jpg'), // Aquí debes colocar la ruta de tu imagen
                              radius: 20.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          ElevatedButton(
                            onPressed: () {
                              // Acción al presionar un presentador
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => Recomendacion2(presentador)),
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                            ),
                            child: Text(
                              presentador,
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
                '¿Qué género de podcasts prefieres?',
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