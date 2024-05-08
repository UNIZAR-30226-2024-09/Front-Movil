import 'package:aversifunciona/cancion.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/reproductor.dart';
import 'package:aversifunciona/salas.dart';
import 'package:flutter/material.dart';

import 'biblioteca.dart';
import 'buscar.dart';
import 'env.dart';
import 'pantallaCancion.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cola.dart';

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

class rap extends StatefulWidget {
  @override
  _rap_State createState() => _rap_State();
}

class _rap_State extends State<rap> {
  List<dynamic> canciones = [];

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
        body: jsonEncode({'genero': 'Rap'}),
      );
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        dynamic cancionesData = data['canciones'];

        List<dynamic> nuevasCanciones = [];

        for (var i = 0; i < cancionesData.length; i++) {
          Cancion cancion = Cancion.fromJson(cancionesData[i]);
          nuevasCanciones.add(cancion);
        }

        setState(() {
          canciones = nuevasCanciones;
        });

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          children: [
            Text('Buscar rap', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, // Eliminar el botón de retroceso predeterminado
      ),
      body: canciones.isEmpty
          ? const Center(child: CircularProgressIndicator()): ListView.builder(
        itemCount: canciones.length,
        itemBuilder: (context, index) {
          String cancion = canciones[index].foto;
          return ListTile(
            leading: Image.memory(base64Url.decode(('data:image/jpeg;base64,${utf8.decode(base64Decode(cancion.replaceAll(RegExp('/^data:image/[a-z]+;base64,/'), '')))}').split(',').last), height: 50, width: 50,),
            title: TextButton(
              onPressed:() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      //builder: (context) => reproductor(cancion: canciones[index], ids: [])
                      builder: (context) => PantallaCancion(songId: canciones[index].id)
                  ),
                );
              },
              child: Row(
                children: [
                  Text(canciones[index].nombre, style: const TextStyle(color: Colors.white, fontSize: 14),),
                  const SizedBox(width: 20,)
                ]
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