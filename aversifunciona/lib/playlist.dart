import 'dart:typed_data';

import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/reproductor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'biblioteca.dart';
import 'buscar.dart';
import 'cancion.dart';
import 'cancionSin.dart';

import 'pantallaCancion.dart';
import 'env.dart';
import 'cola.dart';
import 'salas.dart';

class Playlist extends StatefulWidget {
  final int playlistId;
  final String playlistName;

  const Playlist({Key? key, required this.playlistId, required this.playlistName}) : super(key: key);

  @override
  _PlaylistState createState() => _PlaylistState(playlistName);
}

class _PlaylistState extends State<Playlist> {
  //bool isPublic = true; // Estado de la playlist (pública o privada)
  String playlistName = '';
  late String userName = '';
  late String duration = '';
  late bool playlistPublica = true;
  late List<Map<String, dynamic>> songs = [];
  final TextEditingController _emailController = TextEditingController();
  bool cargado = false;
  List<int> ids = [];
  List<CancionSin> canciones= [];

  _PlaylistState(String name){
    playlistName = name;
  }

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
          playlistPublica = playlistData['publica'] ?? false; // Usar false como valor por defecto si 'publica' es null
          // Otros datos...
        } else {
          // Manejar el caso en el que playlistData es null
          debugPrint('playlistData es null');
        }

        setState(() {
          // Actualizar los datos de la playlist con los recibidos de la API
          playlistPublica = playlistData['publica'];
          // Otros datos...
        });
        debugPrint('Playlist: $playlistName');
        debugPrint('Pública: $playlistPublica');
        _fetchPlaylistSongs();
      } else {
        throw Exception('Error al obtener los datos de la playlist');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al obtener los datos de la playlist'),
        ),
      );
    }
  }


  Future<void> _fetchPlaylistSongs() async {
    List<CancionSin> canciones_ = [];
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

        for (var i = 0; i < songsData.length; i++) {
          CancionSin cancion = CancionSin.fromJson(songsData[i]);
          canciones_.add(cancion);
          ids.add(canciones_[i].id!);
        }

        // Actualizar la lista de canciones con los datos recibidos de la API
        setState(() {
          songs = List<Map<String, dynamic>>.from(songsData);
          canciones = canciones_;
          cargado = true;
        });
        // Iterar sobre la lista de canciones y obtener los artistas de cada una
        for (var song in songs) {
          await _fetchSongArtists(song['id']);
        }
      } else {
        throw Exception('Error al obtener las canciones de la playlist');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al obtener las canciones de la playlist'),
        ),
      );
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

  Future<Uint8List> _fetchAudioFromUrl(String audioUrl) async {
    final response = await http.get(Uri.parse(audioUrl));
    if (response.statusCode == 200) {
      // Devuelve los bytes de la imagen
      return response.bodyBytes;
    } else {
      // Si la solicitud falla, lanza un error
      throw Exception('Failed to load audio from $audioUrl');
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
          songs.firstWhere((song) => song['id'] == songId)['artista'] = List<Map<String, dynamic>>.from(artistsData);
        });
        print(artistsData);
      } else {
        throw Exception('Error al obtener los artistas de la canción $songId');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al obtener los artistas de la canción $songId'),
        ),
      );
    }
  }

  void _deleteSongFromPlaylist(int songId) async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/eliminarCancionPlaylist/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'playlistId': widget.playlistId,
          'cancionId': songId,
        }),
      );
      if (response.statusCode == 200) {
        // Eliminación exitosa
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Canción eliminada de la playlist'),
          ),
        );
        // Actualizar la lista de canciones después de eliminar la canción
        setState(() {
          songs.removeWhere((song) => song['id'] == songId);
        });
      } else {
        throw Exception('Error al eliminar la canción de la playlist');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al eliminar la canción de la playlist'),
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
        title: const Text('Playlist', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              _showAddCollaboratorModal(context);
            },
            icon: const Icon(Icons.person_add, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _togglePlaylistPrivacy();
              },
              child: Text(playlistPublica ? 'Cambiar a Privada' : 'Cambiar a Pública'),
            ),
            const SizedBox(height: 20),
            // Aquí iría la foto de la playlist (cuadrada, en el centro, dentro de un contenedor gris)
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Container(
                    color: Colors.grey.withOpacity(0.5),
                    child: Center(
                      child: Image.asset('lib/playlist.jpg'),
                    ),
                  ),
                ),
              ),
            ),
        
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        playlistName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Duración: $duration',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(

                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white), ),
                        onPressed: () async{
                          // Lógica para reproducir la playlist
                          ids.shuffle();
                          Cancion? song;
                          for (var cancion in canciones){
                            if(ids[0] == cancion.id){
                              Uint8List image = await _fetchImageFromUrl('${Env.URL_PREFIX}/imagenCancion/${cancion.id}/');
                              Uint8List audio = await _fetchAudioFromUrl('${Env.URL_PREFIX}/audioCancion/${cancion.id}/');
                              Cancion cancion2 = Cancion(id: cancion.id, nombre: cancion.nombre, miAlbum: cancion.miAlbum, puntuacion: cancion.puntuacion, archivomp3: audio, foto: image);
                              song = cancion2;
                            }
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Reproductor(cancion: song, ids: ids)), // cancion: cancion dentro de reproductor cuando esto funcione
                          );
                        },
                        child: const Icon(Icons.shuffle, color: Colors.green),
                      ),
                      const SizedBox(width: 10,),
                      ElevatedButton.icon(
                        onPressed: () async {
                          // Lógica para reproducir la playlist
                          Cancion? song;
                          for (var cancion in canciones){
                            if(ids[0] == cancion.id){
                              Uint8List image = await _fetchImageFromUrl('${Env.URL_PREFIX}/imagenCancion/${cancion.id}/');
                              Uint8List audio = await _fetchAudioFromUrl('${Env.URL_PREFIX}/audioCancion/${cancion.id}/');
                              Cancion cancion2 = Cancion(id: cancion.id, nombre: cancion.nombre, miAlbum: cancion.miAlbum, puntuacion: cancion.puntuacion, archivomp3: audio, foto: image);
                              song = cancion2;
                            }
                          }
        
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Reproductor(cancion: song, ids: ids)), // cancion: cancion dentro de reproductor cuando esto funcione
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Play'),
                      ),
                    ],
                  )
        
                ],
              ),
            ),
            const SizedBox(height: 20),
            !cargado ? const CircularProgressIndicator(): Container(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  final artistas = song['artista'] as List<Map<String, dynamic>>?;
                  final artistasString =
                  artistas != null ? artistas.map((artista) => artista['nombre']).join(', ') : 'Artistas no disponibles';
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteSongFromPlaylist(song['id']); // Eliminar la canción de la playlist
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Verificar si song['cancionId'] no es nulo antes de pasar a PantallaCancion
                        if (song['id'] != null) {
                          // Navegar a la pantalla de detalles de la canción
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PantallaCancion(songId: song['id'])),
                          );
                        }
                      },
                      child: ListTile(
                        leading: const Icon(Icons.music_note),
                        title: Text(song['nombre'] ?? 'Nombre no disponible', style: const TextStyle(color: Colors.white)),
                        subtitle: Text(artistasString, style: const TextStyle(color: Colors.grey)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
          child: const Icon(Icons.queue_music),
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
          const SnackBar(
            content: Text('La playlist ha sido actualizada con éxito'),
          ),
        );
      } else {
        throw Exception('Error al cambiar la privacidad de la playlist');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al cambiar la privacidad de la playlist'),
        ),
      );
    }
  }

  void _showAddCollaboratorModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir Colaborador'),
          content: TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'Correo Electrónico',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _addCollaborator();
                Navigator.of(context).pop();
              },
              child: const Text('Añadir Colaborador'),
            ),
          ],
        );
      },
    );
  }

  void _addCollaborator() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/agnadirColaboradorAPI/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': _emailController.text,
          'playlistId': widget.playlistId,
        }),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Colaborador añadido con éxito'),
          ),
        );
      } else {
        throw Exception('Error al añadir el colaborador');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al añadir el colaborador'),
        ),
      );
    }
  }
}