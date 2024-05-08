import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/podcast.dart';
import 'package:aversifunciona/reproductor.dart';
import 'package:aversifunciona/salas.dart';
import 'package:flutter/material.dart';

import 'biblioteca.dart';
import 'buscar.dart';
import 'env.dart';

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

class psicologia extends StatefulWidget {
  @override
  _psicologia_State createState() => _psicologia_State();
}

class _psicologia_State extends State<psicologia> {
  List<dynamic> podcasts = [];

  @override
  void initState() {
    super.initState();
    filtrarPodcasts();
  }

  Future<void> filtrarPodcasts() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/filtrarPodcastsPorGenero/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'genero': 'Psicología'}),
      );
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        dynamic podcastsData = data['podcasts'];

        List<dynamic> nuevosPodcasts = [];

        for (var i = 0; i < podcastsData.length; i++) {
          Podcast podcast = Podcast.fromJson(podcastsData[i]);
          nuevosPodcasts.add(podcast);
        }

        setState(() {
          podcasts = nuevosPodcasts;
        });

      } else {
        // Handle error or unexpected status code
        throw Exception('Failed to load podcasts');
      }
    } catch (e) {
      // Handle any errors that occur during the request
      throw Exception('Error fetching podcasts: $e');
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
            Text('Buscar psicología', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, // Eliminar el botón de retroceso predeterminado
      ),
      body: podcasts.isEmpty
          ? const Center(child: CircularProgressIndicator()): ListView.builder(
        itemCount: podcasts.length,
        itemBuilder: (context, index) {
          String podcast = podcasts[index].foto;
          return ListTile(
            leading: Image.memory(base64Url.decode(('data:image/jpeg;base64,${utf8.decode(base64Decode(podcast.replaceAll(RegExp('/^data:image/[a-z]+;base64,/'), '')))}').split(',').last), height: 50, width: 50,),
            title: TextButton(
              onPressed:() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => reproductor(cancion: podcasts[index], ids: [-33],)
                  ),
                );
              },
              child: Row(
                  children: [
                    Text(podcasts[index].nombre, style: const TextStyle(color: Colors.white, fontSize: 14),),
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