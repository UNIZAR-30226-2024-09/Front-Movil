import 'dart:typed_data';

import 'package:aversifunciona/biblioteca.dart';
import 'package:aversifunciona/buscar.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/reproductor.dart';
import 'package:aversifunciona/salas.dart';
import 'package:flutter/material.dart';

import 'capitulo.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cola.dart';
import 'getUserSession.dart';
import 'env.dart';
import 'pantallaCapitulo.dart';

class PantallaPodcast extends StatefulWidget {
  final int podcastId;
  final String podcastName;


  const PantallaPodcast({Key? key, required this.podcastId, required this.podcastName}) : super(key: key);

  @override
  _PantallaPodcastState createState() => _PantallaPodcastState(podcastName);
}

class _PantallaPodcastState extends State<PantallaPodcast> {
  String podcastName = '';
  late String userName = '';
  late String duration = '';
  late List<Map<String, dynamic>> capitulos1 = [];
  final TextEditingController _emailController = TextEditingController();
  bool cargado = false;
  int id_podcast = 0;
  List<int> ids = [];
  List<Capitulo> capitulos2= [];
  Uint8List imagen=Uint8List(0);

  _PantallaPodcastState(String name){
    podcastName = name;
  }

  @override
  void initState() {
    super.initState();
    // Obtener los datos de la playlist al inicializar el widget
    _fetchPodcastData();
  }

  Future<void> _fetchPodcastData() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/devolverPodcast/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'podcastId': widget.podcastId,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final podcastData = responseData['podcast'];

        print('Podcast: $podcastName');
        imagen = await _fetchImageFromUrl('${Env.URL_PREFIX}/imagenPodcast/${widget.podcastId}/');
        _fetchPodcastEpisodes();
        setState(() {
          id_podcast = widget.podcastId;
        });
      } else {
        throw Exception('Error al obtener los datos del podcast');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al obtener los datos del podcast'),
        ),
      );
    }
  }


  Future<void> _fetchPodcastEpisodes() async {
    List<Capitulo> capitulos_ = [];
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarCapitulosPodcast/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombrePodcast': widget.podcastName,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final episodesData = responseData['capitulos'];


        for (var i = 0; i < episodesData.length; i++) {
          Capitulo capitulo = Capitulo.fromJson(episodesData[i]);
          capitulos_.add(capitulo);
          ids.add(capitulos_[i].id!);
        }

        // Actualizar la lista de canciones con los datos recibidos de la API
        setState(() {
          capitulos1 = List<Map<String, dynamic>>.from(episodesData);
          capitulos2 = capitulos_;
          cargado = true;
        });
        // Iterar sobre la lista de canciones y obtener los artistas de cada una

      } else {
        throw Exception('Error al obtener los capítulos del podcast');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al obtener las canciones de la playlist'),
        ),
      );
    }
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
        title: const Text('Podcast', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 200,
              height: 200,
              color: Colors.grey.withOpacity(0.5),
              child: Center(
                child: imagen.isNotEmpty // Verifica si la lista de bytes de la imagen no está vacía
                    ? Image.memory(
                  imagen,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover, // Ajusta la imagen para que cubra el contenedor
                )
                    : CircularProgressIndicator(), // Muestra un indicador de carga si la lista de bytes está vacía
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
                        podcastName,
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
                      const SizedBox(width: 10,),
                      ElevatedButton.icon(
                        onPressed: () {

                          // Lógica para reproducir la playlist
                          ids = [-33];
                          ids.add(id_podcast);
                          Capitulo capitulo = Capitulo(id: capitulos1[0]['id'], nombre: capitulos1[0]['nombre'], descripcion: capitulos1[0]['descripcion'], miPodcast: capitulos1[0]['miPodcast'], archivomp3: null);
                          Navigator.push(

                            context,
                            MaterialPageRoute(builder: (context) => Reproductor(cancion: capitulo, ids: ids, playlist: 'Reproduciendo podcast: $podcastName',)), // cancion: cancion dentro de reproductor cuando esto funcione
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
                itemCount: capitulos1.length,
                itemBuilder: (context, index) {
                  final capitulo = capitulos1[index];
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
                        if (capitulo['id'] != null) {
                          // Navegar a la pantalla de detalles de la canción
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PantallaCapitulo(capituloId: capitulo['id'])),
                          );
                        }
                      },
                      child: ListTile(
                        leading: FutureBuilder<Uint8List>(
                          future: _fetchImageFromUrl('${Env.URL_PREFIX}/imagenPodcast/${widget.podcastId}/'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox(); // Devuelve un widget vacío mientras espera
                            } else if (snapshot.hasError) {
                              return const Icon(Icons.error);
                            } else {
                              return Image.memory(
                                snapshot.data!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              );
                            }
                          },
                        ),
                        title: Text(capitulo['nombre'] ?? 'Nombre no disponible', style: const TextStyle(color: Colors.white)),
                        //subtitle: Text(artistasString, style: const TextStyle(color: Colors.grey)),
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

