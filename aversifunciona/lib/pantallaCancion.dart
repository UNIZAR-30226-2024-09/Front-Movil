import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'getUserSession.dart';
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
    _fetchSongData();
    _getUserInfo();
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
        await _fetchAlbumName(album);
        await _fetchArtistName(album);
      } else {
        throw Exception('Error al obtener los datos de la canción');
      }
    } catch (e) {
      print('Error: $e');
      // Manejar el error aquí
    }
  }

  Future<void> _fetchAlbumName(int albumId) async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/devolverAlbum/'), // Reemplaza con la URL de tu API
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'albumId': albumId,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final albumData = responseData['album'];
        final albumName = albumData['nombre']; // Suponiendo que 'nombre' es el campo que contiene el nombre del álbum
        setState(() {
          // Actualizar el estado con el nombre del álbum
          // Aquí puedes asignar el nombre del álbum a una variable en el estado si es necesario
          this.albumName = albumName;
        });
      } else {
        throw Exception('Error al obtener el nombre del álbum');
      }
    } catch (e) {
      print('Error: $e');
      // Manejar el error aquí
    }
  }

  Future<void> _fetchArtistName(int albumId) async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarArtistasCancion/'), // Reemplaza con la URL de tu API
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'albumId': albumId,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final artistData = responseData['artistas'];
        final artistName = artistData['nombre']; // Suponiendo que 'nombre' es el campo que contiene el nombre del álbum
        setState(() {
          // Actualizar el estado con el nombre del álbum
          // Aquí puedes asignar el nombre del álbum a una variable en el estado si es necesario
          this.artistName = artistName;
        });
      } else {
        throw Exception('Error al obtener el nombre del artista');
      }
    } catch (e) {
      print('Error: $e');
      // Manejar el error aquí
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

  Future<void> _addToQueue() async {
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
  }

  Future<void> _fetchUserPlaylists() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarPlaylistsUsuario/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'correo': _correoS}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Response: $responseData');
        if (responseData.containsKey('playlists') && responseData['playlists'] != null) {
          final List<dynamic> playlistData = responseData['playlists'];
          final List<String> playlists = [];
          final Map<String, int> playlistIds = {}; // Mapa para guardar IDs de playlists

          playlistData.forEach((data) {
            final nombre = data['nombre'].toString();
            final id = data['id'] as int;
            playlists.add(nombre);
            playlistIds[nombre] = id; // Asociar nombre de playlist con su ID
          });

          setState(() {
            _playlists = playlists;
            _playlistsIds = playlistIds; // Guardar el mapa de IDs de playlist
          });
        } else {
          print('No se encontraron listas de reproducción para este usuario.');
        }
      } else {
        print('Else: Error al obtener las playlists: ${response.statusCode}');
      }
    } catch (e) {
      print('Catch: Error fetching user playlists: $e');
    }
  }

  Future<void> _addToPlaylist(String playlistName) async {
    try {
      final playlistId = _playlistsIds[playlistName];
      if (playlistId != null) {
        final response = await http.post(
          Uri.parse('${Env.URL_PREFIX}/agnadirCancionPlaylist/'), // Reemplaza con la URL de tu API
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'playlistId': playlistId,
            'cancionId': widget.songId,
          }),
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Canción añadida a la playlist con éxito'),
            ),
          );
        } else if (response.statusCode == 400) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('La canción ya está en la playlist'),
            ),
          );
          throw Exception('La canción ya está en la playlist');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al añadir la canción a la playlist'),
            ),
          );
          throw Exception('Error al añadir la canción a la playlist');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se encontró la playlist correspondiente'),
          ),
        );
        throw Exception('No se encontró la playlist correspondiente');
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
                  onPressed: _addToQueue,
                  icon: Icon(Icons.queue),
                  label: Text('Añadir a la Cola'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _fetchUserPlaylists();
                    _showPlaylistModal(context);
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

  void _showPlaylistModal(BuildContext context) async {
    await _fetchUserPlaylists(); // Llamar a la API para obtener las playlists antes de mostrar el modal
    showModalBottomSheet(
      backgroundColor: Colors.transparent, // Para evitar que el fondo tenga un color gris
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7, // Altura máxima del modal
          ),
          decoration: BoxDecoration(
            color: Colors.grey[900], // Color de fondo del modal
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del Column al mínimo
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Elija una playlist',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _playlists.length,
                  itemBuilder: (context, index) {
                    final playlistName = _playlists[index];
                    return GestureDetector(
                      onTap: () {
                        _addToPlaylist(playlistName); // Llamada a _addToPlaylist aquí
                        Navigator.pop(context); // Cerrar el modal al seleccionar una playlist
                      },
                      child: ListTile(
                        title: Text(
                          playlistName,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}