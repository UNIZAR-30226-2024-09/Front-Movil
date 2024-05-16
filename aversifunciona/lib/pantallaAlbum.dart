import 'dart:typed_data';

import 'package:aversifunciona/biblioteca.dart';
import 'package:aversifunciona/buscar.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/reproductor.dart';
import 'package:aversifunciona/salas.dart';
import 'package:flutter/material.dart';

import 'cancion.dart';
import 'cancionSin.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cola.dart';
import 'getUserSession.dart';
import 'env.dart';
import 'pantallaCancion.dart';

class PantallaAlbum extends StatefulWidget {
  final int albumId;
  final String albumName;

  const PantallaAlbum({Key? key, required this.albumId, required this.albumName}) : super(key: key);

  @override
  _PantallaAlbumState createState() => _PantallaAlbumState(albumName);
}

class _PantallaAlbumState extends State<PantallaAlbum> {
  String albumName = '';
  late String userName = '';
  late String duration = '';
  late List<Map<String, dynamic>> canciones1 = [];
  final TextEditingController _emailController = TextEditingController();
  bool cargado = false;
  List<int> ids = [];
  List<CancionSin> canciones2= [];

  _PantallaAlbumState(String name){
    albumName = name;
  }

  @override
  void initState() {
    super.initState();
    // Obtener los datos de la playlist al inicializar el widget
    _fetchAlbumData();
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
  Future<void> _fetchAlbumData() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/devolverAlbum/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'albumId': widget.albumId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final albumData = responseData['album'];

        _fetchAlbumSongs();
      } else {
        throw Exception('Error al obtener los datos del album');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al obtener los datos del album'),
        ),
      );
    }
  }


  Future<void> _fetchAlbumSongs() async {
    List<CancionSin> canciones_ = [];
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarCancionesAlbum/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombreAlbum': widget.albumName,
        }),

      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final cancionesData = responseData['canciones'];

        for (var i = 0; i < cancionesData.length; i++) {
          CancionSin cancion = CancionSin.fromJson(cancionesData[i]);
          canciones_.add(cancion);
          ids.add(canciones_[i].id!);
        }

        // Actualizar la lista de canciones con los datos recibidos de la API
        setState(() {
          canciones1 = List<Map<String, dynamic>>.from(cancionesData);
          canciones2 = canciones_;
          cargado = true;
        });
        // Iterar sobre la lista de canciones y obtener los artistas de cada una

      } else {
        throw Exception('Error al obtener las canciones del album');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al obtener las canciones del album'),
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
        title: const Text('Album', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                      albumName,
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

                      //style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white), ),
                      onPressed: () async{
                        // Lógica para reproducir la playlist
                        ids.shuffle();
                        Cancion? song;
                        for (var cancion in canciones2){
                          if(ids[0] == cancion.id){
                            Uint8List image = await _fetchImageFromUrl('${Env.URL_PREFIX}/imagenCancion/${cancion.id}/');
                            Uint8List audio = await _fetchAudioFromUrl('${Env.URL_PREFIX}/audioCancion/${cancion.id}/');
                            Cancion cancion2 = Cancion(id: cancion.id, nombre: cancion.nombre, miAlbum: cancion.miAlbum, puntuacion: cancion.puntuacion, archivomp3: audio, foto: image);
                            song = cancion2;
                          }
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Reproductor(cancion: song, ids: ids, playlist: 'Reproduciendo desde: $albumName',)), // cancion: cancion dentro de reproductor cuando esto funcione

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

                  ],
                )

              ],
            ),
          ),
          const SizedBox(height: 20),
          !cargado ? const CircularProgressIndicator(): Expanded(
            child: ListView.builder(
              itemCount: canciones1.length,
              itemBuilder: (context, index) {
                final cancion = canciones1[index];
                //final artistas = capitulo['artista'] as List<Map<String, dynamic>>?;
                //final artistasString =
                //artistas != null ? artistas.map((artista) => artista['nombre']).join(', ') : 'Artistas no disponibles';
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    //_deleteSongFromPlaylist(song['id']); // Eliminar la canción de la playlist
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
                      if (cancion['id'] != null) {
                        // Navegar a la pantalla de detalles de la canción
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PantallaCancion(songId: cancion['id'])),
                        );
                      }
                    },
                    child: ListTile(
                      leading: const Icon(Icons.music_note),
                      title: Text(cancion['nombre'] ?? 'Nombre no disponible', style: const TextStyle(color: Colors.white)),
                      //subtitle: Text(artistasString, style: const TextStyle(color: Colors.grey)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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

class SalasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salas'),
      ),
      body: Center(
        child: Text('Contenido de la pantalla Salas'),
      ),
    );
  }
}

