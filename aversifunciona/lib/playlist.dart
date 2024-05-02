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
  //bool isPublic = true; // Estado de la playlist (pública o privada)
  late String playlistName = '';
  late String userName = '';
  late String duration = '';
  late bool playlistPublica = true;
  late List<Map<String, dynamic>> songs = [];

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

        if (playlistData != null) {
          // Acceder a las propiedades de playlistData
          playlistName = playlistData['nombre'] ?? ''; // Usar cadena vacía como valor por defecto si 'nombre' es null
          playlistPublica = playlistData['publica'] ?? false; // Usar false como valor por defecto si 'publica' es null
          // Otros datos...
        } else {
          // Manejar el caso en el que playlistData es null
          print('playlistData es null');
        }

        setState(() {
          // Actualizar los datos de la playlist con los recibidos de la API
          playlistName = playlistData['nombre'];
          playlistPublica = playlistData['publica'];
          // Otros datos...
        });
        print('Playlist: $playlistName');
        print('Pública: $playlistPublica');
        _fetchPlaylistSongs();
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


  Future<void> _fetchPlaylistSongs() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarCancionesPlaylist/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'playlistId': widget.playlistId,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final songsData = responseData['canciones'];
        // Actualizar la lista de canciones con los datos recibidos de la API
        setState(() {
          songs = List<Map<String, dynamic>>.from(songsData);
        });
        // Iterar sobre la lista de canciones y obtener los artistas de cada una
        for (var song in songs) {
          await _fetchSongArtists(song['cancionId']);
        }
      } else {
        throw Exception('Error al obtener las canciones de la playlist');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al obtener las canciones de la playlist'),
        ),
      );
    }
  }

  Future<void> _fetchSongArtists(String songId) async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarArtistasCancion/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cancionId': songId,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final artistsData = responseData['artistas'];
        // Actualizar los artistas de la canción en la lista de canciones
        setState(() {
          songs.firstWhere((song) => song['cancionId'] == songId)['artista'] = List<Map<String, dynamic>>.from(artistsData);
        });
      } else {
        throw Exception('Error al obtener los artistas de la canción $songId');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al obtener los artistas de la canción $songId'),
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
            child: Text(playlistPublica ? 'Cambiar a Privada' : 'Cambiar a Pública'),
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
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                final artistas = song['artistas'] as List<Map<String, dynamic>>?;
                final artistasString = artistas != null ? artistas.map((artista) => artista['nombre']).join(', ') : 'Artistas no disponibles';
                return ListTile(
                  leading: Icon(Icons.music_note),
                  title: Text(song['nombre'] ?? 'Nombre no disponible', style: TextStyle(color: Colors.white)),
                  subtitle: Text(artistasString, style: TextStyle(color: Colors.grey)),
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
          'nombre': playlistName,
          'publica': !playlistPublica, // Cambia el estado de publica
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          // Actualiza el estado local y cambia el texto del botón
          playlistPublica = !playlistPublica;
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

