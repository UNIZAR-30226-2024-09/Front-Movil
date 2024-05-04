import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'env.dart';

class PantallaCancion extends StatefulWidget {
  final int songId;

  PantallaCancion({required this.songId});

  @override
  _PantallaCancionState createState() => _PantallaCancionState();
}

class _PantallaCancionState extends State<PantallaCancion> {
  late String nombre = '';
  late int album = 0;
  late String artista = '';
  late String duracion = '';

  @override
  void initState() {
    super.initState();
    _fetchSongData();
  }

  Future<void> _fetchSongData() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/devolverCancion/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cancionId': widget.songId,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final songData = responseData['cancion'];
        setState(() {
          nombre = songData['nombre'];
          album = songData['miAlbum'];
        });
      } else {
        throw Exception('Error al obtener los datos de la canción');
      }
    } catch (e) {
      print('Error: $e');
      // Manejar el error aquí
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
        title: Text('Detalles de la Canción', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Container(
              width: 200,
              height: 200,
              color: Colors.grey.withOpacity(0.5),
              child: Center(
                child: Icon(
                  Icons.music_note,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Lógica para añadir a la cola
                  },
                  icon: Icon(Icons.queue),
                  label: Text('Añadir a la Cola'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Lógica para añadir a una playlist
                  },
                  icon: Icon(Icons.playlist_add),
                  label: Text('Añadir a Playlist'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  nombre,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    // Lógica para reproducir la canción
                  },
                  icon: Icon(Icons.play_arrow, size: 40),
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '$album - $artista',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Duración: $duracion',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
