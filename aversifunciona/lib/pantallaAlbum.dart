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

class Album extends StatefulWidget {
  final int albumId;
  final String albumName;

  const Album({Key? key, required this.albumId, required this.albumName}) : super(key: key);

  @override
  _AlbumState createState() => _AlbumState(albumName);
}

class _AlbumState extends State<Album> {
  String albumName = '';
  late String userName = '';
  late String duration = '';
  late bool albumPublico = true;
  late List<Map<String, dynamic>> songs = [];
  final TextEditingController _emailController = TextEditingController();
  bool cargado = false;
  List<int> ids = [];
  List<CancionSin> canciones = [];

  _AlbumState(String name) {
    albumName = name;
  }

  @override
  void initState() {
    super.initState();
    // Obtener los datos del álbum al inicializar el widget
    _fetchAlbumData();
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

        if (albumData != null) {
          // Acceder a las propiedades de albumData
          albumPublico = albumData['publico'] ?? false; // Usar false como valor por defecto si 'publico' es null
          // Otros datos...
        } else {
          // Manejar el caso en el que albumData es null
          debugPrint('albumData es null');
        }

        setState(() {
          // Actualizar los datos del álbum con los recibidos de la API
          albumPublico = albumData['publico'];
          // Otros datos...
        });
        debugPrint('Álbum: $albumName');
        debugPrint('Público: $albumPublico');
        _fetchAlbumSongs();
      } else {
        throw Exception('Error al obtener los datos del álbum');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al obtener los datos del álbum'),
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
          'albumId': widget.albumId,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData.containsKey('canciones')) {
          final songsData = responseData['canciones'];
          if (songsData.isNotEmpty) {
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
          }
        } else if (responseData.containsKey('message')) {
          setState(() {
            canciones = []; // Limpiar la lista de canciones
            cargado = true; // Marcar como cargado para evitar el indicador de carga
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('El álbum no tiene canciones'),
            ),
          );
        }
      } else {
        throw Exception('Error al obtener las canciones del álbum');
      }
    } catch (e) {
      debugPrint('Error fetchAlbumSongs: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al obtener las canciones del álbum'),
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

  Future<void> _fetchSongArtists(int songId) async {
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
        print("artistas: $artistsData");
      } else {
        throw Exception('Error al obtener los artistas de la canción $songId');
      }
    } catch (e) {
      debugPrint('Error fetchSongArtists: $e');
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
    title: const Text('Álbum', style: TextStyle(color: Colors.white)),
    ),
    body: SingleChildScrollView(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    const SizedBox(height: 20),
    // Aquí iría la foto del álbum (cuadrada, en el centro, dentro de un contenedor gris)
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
    child: Image.asset('lib/album.jpg'),
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
    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white),),
    onPressed: () async {
    // Lógica para reproducir el álbum
    ids.shuffle();
    Cancion? song;
    for (var cancion in canciones) {
    if (ids[0] == cancion.id
    ) {
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
    child: const Icon(Icons.shuffle, color: Colors.green),
    ),
    const SizedBox(width: 10,),
    ElevatedButton.icon(
    onPressed: () async {
    // Lógica para reproducir el álbum
    Cancion? song;
    for (var cancion in canciones) {
    if (ids[0] == cancion.id) {
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
    _deleteSongFromAlbum(song['id']); // Eliminar la canción del álbum
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
    leading: FutureBuilder<Uint8List>(
    future: _fetchImageFromUrl('${Env.URL_PREFIX}/imagenCancion/${song['id']}/'),
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
    onPressed
        : () {
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

  void _toggleAlbumPrivacy() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/actualizarAlbum/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'albumId': widget.albumId,
          'nombre': albumName,
          'publico': !albumPublico, // Cambia el estado de publico
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          // Actualiza el estado local y cambia el texto del botón
          albumPublico = !albumPublico;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El álbum ha sido actualizado con éxito'),
          ),
        );
      } else {
        throw Exception('Error al cambiar la privacidad del álbum');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al cambiar la privacidad del álbum'),
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
        Uri.parse('${Env.URL_PREFIX}/agnadirColaboradorAlbum/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': _emailController.text,
          'albumId': widget.albumId,
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

  void _deleteSongFromAlbum(int songId) async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/eliminarCancionAlbum/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'albumId': widget.albumId,
          'cancionId': songId,
        }),
      );
      if (response.statusCode == 200) {
        // Eliminación exitosa
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Canción eliminada del álbum'),
          ),
        );
        // Actualizar la lista de canciones después de eliminar la canción
        setState(() {
          songs.removeWhere((song) => song['id'] == songId);
        });
      } else {
        throw Exception('Error al eliminar la canción del álbum');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al eliminar la canción del álbum'),
        ),
      );
    }
  }
}
