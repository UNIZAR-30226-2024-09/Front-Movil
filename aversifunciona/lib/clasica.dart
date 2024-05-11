// Importaciones necesarias
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:aversifunciona/env.dart'; // Asumiendo que este archivo contiene la URL_PREFIX
import 'package:aversifunciona/cancion.dart';
import 'PantallaCancion.dart'; // Asumiendo que este archivo contiene la definición de PantallaCancion
import 'cola.dart';
import 'biblioteca.dart';
import 'buscar.dart';
import 'salas.dart';
import 'pantalla_principal.dart';

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

class clasica extends StatefulWidget {
  @override
  _clasica_State createState() => _clasica_State();
}

class _clasica_State extends State<clasica> {
  List<Map<String, dynamic>> canciones = []; // Cambio de tipo de lista

  @override
  void initState() {
    super.initState();
    filtrarCanciones();
  }

  Future<void> filtrarCanciones() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/filtrarCancionesPorGenero/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'genero': 'Clasica'}),
      );
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> cancionesData = data['canciones'];

        final List<Map<String, dynamic>> cancionesAux = cancionesData.map((cancion) {
          return {
            'id': cancion['id'] as int,
            'nombre': cancion['nombre'] as String,
            //'foto': cancion['foto'] as String,
          };
        }).toList();

        setState(() {
          canciones = cancionesAux;
        });
      } else {
        throw Exception('Failed to load songs');
      }
    } catch (e) {
      throw Exception('Error fetching songs: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          children: [
            Text('Buscar clasica', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, // Eliminar el botón de retroceso predeterminado
      ),
      body: canciones.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: canciones.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PantallaCancion(songId: canciones[index]['id'])
                  ),
                );
              },
              child: Row(
                children: [
                  FutureBuilder<Uint8List>(
                    future: _fetchImageFromUrl('${Env.URL_PREFIX}/imagenCancion/${canciones[index]['id']}/'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Icon(Icons.error);
                      } else {
                        return Image.memory(
                          snapshot.data!,
                          width: 50, // Tamaño fijo para la imagen
                          height: 50, // Tamaño fijo para la imagen
                          fit: BoxFit.cover,
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  Text(canciones[index]['nombre'], style: const TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            ),
          );
        },
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
                  MaterialPageRoute(
                      builder: (context) => pantalla_principal()),
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
                  MaterialPageRoute(
                      builder: (context) => pantalla_buscar()),
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
                  MaterialPageRoute(
                      builder: (context) => pantalla_biblioteca()),
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
                  MaterialPageRoute(
                      builder: (context) => pantalla_salas()),
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
}