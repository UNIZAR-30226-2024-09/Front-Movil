import 'dart:typed_data';

import 'package:aversifunciona/reproductor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'getUserSession.dart';
import 'env.dart';
import 'cancion.dart';



class PantallaCapitulo extends StatefulWidget {
  final int capituloId;

  PantallaCapitulo({required this.capituloId});

  @override
  _PantallaCapituloState createState() => _PantallaCapituloState();
}

class _PantallaCapituloState extends State<PantallaCapitulo> {
  late String nombre = '';
  late int cap_id = 0 ;
  late String archivoMP3 = '';
  late int podcast = 0;
  late int p_id = 0;
  late String albumName = '';
  late String artistName = '';
  late String artista = '';
  late String duracion = '';
  String _correoS = '';
  List<String> playlists = []; // Lista de playlists del usuario
  List<String> _playlists = [];
  Map<String, int> _playlistsIds = {};

  @override
  void initState() {
    super.initState();
    _fetchEpisodeData();
    _getUserInfo();
  }

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

  Future<void> _getUserInfo() async {
    try {
      String? token = await getUserSession.getToken(); // Espera a que el token se resuelva
      print("Token: $token");
      if (token != null) {
        // Llama al método AuthService para obtener la información del usuario
        Map<String, dynamic> userInfo = await getUserSession.getUserInfo(token);
        print(userInfo);
        setState(() {
          _correoS = userInfo['correo'];
        });
      } else {
        print('Token is null');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> _fetchEpisodeData() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/devolverCapitulo/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'capituloId': widget.capituloId,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final songData = responseData['capitulo'];
        setState(() {
          cap_id = songData['id'];
          nombre = songData['nombre'];
          podcast = songData['miPodcast'];
          archivoMP3 = songData['archivoMp3'];
        });
        await _fetchPodcastName(podcast);
        //await _fetchArtistName(album);
      } else {
        throw Exception('Error al obtener los datos de la canción');
      }
    } catch (e) {
      print('Error: $e');
      // Manejar el error aquí
    }
  }

  Future<void> _fetchPodcastName(int podcastId) async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/devolverPodcast/'), // Reemplaza con la URL de tu API
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'podcastId': podcastId,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final podcastData = responseData['podcast'];
        final podcastName = podcastData['nombre']; // Suponiendo que 'nombre' es el campo que contiene el nombre del álbum
        setState(() {
          // Actualizar el estado con el nombre del podcast
          p_id = podcastData['id'];
          podcast = podcastName;
        });
      } else {
        throw Exception('Error al obtener el nombre del podcast');
      }
    } catch (e) {
      print('Error: $e');
      // Manejar el error aquí
    }
  }

  /*Future<void> _addToQueue() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/agnadirCancionCola/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': _correoS, // Correo del usuario
          'cancionId': widget.songId,
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Canción añadida a la cola de reproducción con éxito'),
          ),
        );
      } else {
        throw Exception('Error al añadir la canción a la cola');
      }
    } catch (e) {
      print('Error: $e');
      // Manejar el error aquí
    }
  }*/

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
        title: Text('Detalles del capítulo', style: TextStyle(color: Colors.white)),
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
              child: const Center(
                child: Icon(
                  Icons.music_note,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /*ElevatedButton.icon(
                  onPressed: _addToQueue,
                  icon: Icon(Icons.queue),
                  label: Text('Añadir a la Cola'),
                ),*/
                ElevatedButton.icon(
                  onPressed: () {
                    //_fetchUserPlaylists();
                    //_showPlaylistModal(context);
                  },
                  icon: const Icon(Icons.playlist_add),
                  label: const Text('Añadir a Playlist'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    ElevatedButton.icon(
                      onPressed: () async {
                        Uint8List datos = await _fetchImageFromUrl('${Env.URL_PREFIX}/imagenPodcast/$p_id/');
                        Cancion capitulo = Cancion(id: cap_id, nombre: nombre, miAlbum: 0, puntuacion: 0, archivomp3: null, foto: datos);

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Reproductor(cancion: capitulo, ids: [-33], /*playlist: 'Reproduciendo capitulo de podcast',*/)),

                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Reproducir'),
                    );

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
                  '$albumName - $artistName',
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