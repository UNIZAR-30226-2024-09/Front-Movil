import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'env.dart';

class Playlist extends StatefulWidget {
  final int playlistId;

  const Playlist({Key? key, required this.playlistId}) : super(key: key);

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  bool isPublic = true; // Estado de la playlist (pública o privada)
  late String playlistName = '';
  late String userName = '';
  late String duration = '';

  @override
  void initState() {
    super.initState();
    // Obtener los datos de la playlist al inicializar el widget
    _fetchPlaylistData();
  }

  Future<void> _fetchPlaylistData() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/devolverPlaylist/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'playlistId': widget.playlistId,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final playlistData = responseData['playlist'];
        setState(() {
          // Actualizar los datos de la playlist con los recibidos de la API
          playlistName = playlistData['nombre'];
          userName = playlistData['usuario'];
          duration = playlistData['duracion'];
        });
      } else {
        throw Exception('Error al obtener los datos de la playlist');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al obtener los datos de la playlist'),
        ),
      );
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
        title: Text('Playlist', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          ElevatedButton(
            onPressed: () {
              _togglePlaylistPrivacy();
            },
            child: Text(isPublic ? 'Cambiar a Privada' : 'Cambiar a Pública'),
          ),
          SizedBox(height: 20),
          // Aquí iría la foto de la playlist (cuadrada, en el centro, dentro de un contenedor gris)
            Container(
              color: Colors.black,
              padding: EdgeInsets.all(20),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Container(
                    color: Colors.grey.withOpacity(0.5),
                    child: Center(
                      child: Text(
                        'Foto de la Playlist',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playlistName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Duración: $duration',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Lógica para reproducir la playlist
                    },
                    icon: Icon(Icons.play_arrow),
                    label: Text('Play'),
                  ),
                ],
              ),
            ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Número de canciones
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.music_note),
                  title: Text('Canción $index', style: TextStyle(color: Colors.white),),
                  subtitle: Text('Artista $index', style: TextStyle(color: Colors.grey),),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _togglePlaylistPrivacy() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/actualizarPlaylist/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'playlistId': widget.playlistId,
          'nombre': 'Playlist de Zineb 2',
          'publica': !isPublic, // Cambia el estado de publica
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          // Actualiza el estado local y cambia el texto del botón
          isPublic = !isPublic;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('La playlist ha sido actualizada con éxito'),
          ),
        );
      } else {
        throw Exception('Error al cambiar la privacidad de la playlist');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cambiar la privacidad de la playlist'),
        ),
      );
    }
  }
}

