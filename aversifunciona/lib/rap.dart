import 'package:aversifunciona/cancion.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:flutter/material.dart';

import 'biblioteca.dart';
import 'buscar.dart';
import 'chatSalaDisponible.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class rap extends StatefulWidget {
  @override
  _rap_State createState() => _rap_State();
}

class _rap_State extends State<rap> {
  List<dynamic> canciones = [];

  @override
  void initState() {
    super.initState();
    /*filtrarCanciones().then((canciones) {
      setState(() {
        this.canciones = canciones;
      });
    });*/
    filtrarCanciones();
  }
  /*
  // función para cargar las canciones desde la API
  Future<List<Cancion>> filtrarCanciones() async {
    try {
      // realizar la solicitud a la API
      final response = await http.post(
          Uri.parse('http://172.0.0.1:8000/filtrarCancionesPorGenero/'),
          body: {'genero': 'rap'});

      // procesar la respuesta de la API
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          canciones = data['canciones'];
        });
      } else {
        // manejar errores ??
      }
    } catch (e) {
      print("Error al realizar la solicitud HTTP: $e");
      return canciones;
    }
  }*/

  Future<List<dynamic>> filtrarCanciones() async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/filtrarCancionesPorGenero/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'genero': 'Rap'}),
      );
      if (response.statusCode == 200) {
        // Assuming the response is a JSON array
        return jsonDecode(response.body);
      } else {
        // Handle error or unexpected status code
        throw Exception('Failed to load songs');
      }
    } catch (e) {
      // Handle any errors that occur during the request
      throw Exception('Error fetching songs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 10),
            Icon(Icons.account_circle, color: Colors.white, size: 30), // Icono redondeado de la foto de perfil
            SizedBox(width: 10),
            Text('Buscar rap', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, // Eliminar el botón de retroceso predeterminado
      ),
      body: ListView.builder(
        itemCount: canciones.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(canciones[index]['nombre']),
            subtitle: Text(canciones[index]['miAlbum']['nombre']),
          );
        },
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
                );              },
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