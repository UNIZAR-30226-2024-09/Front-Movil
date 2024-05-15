import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

import 'package:aversifunciona/biblioteca.dart';
import 'package:aversifunciona/pantallaAlbum.dart';
import 'package:aversifunciona/pantallaArtista.dart';
import 'package:aversifunciona/pantallaPresentador.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/perfilAjeno.dart';
import 'package:aversifunciona/pop.dart';
import 'package:aversifunciona/reggaeton.dart';
import 'package:aversifunciona/rock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aversifunciona/salas.dart';
import 'package:http/http.dart' as http;
import 'ciencias.dart';
import 'clasica.dart';
import 'cultura.dart';
import 'ejercicio.dart';
import 'enElCoche.dart';
import 'ingles.dart';
import 'psicologia.dart';
import 'electro.dart';
import 'rap.dart';
import 'env.dart';
import 'cola.dart';
import 'relax.dart';
import 'pantallaCancion.dart';
import 'pantallaCapitulo.dart';
import 'pantallaPodcast.dart';
import 'album.dart';


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

class HistorialItem {
  final String term;
  final DateTime timestamp;

  HistorialItem(this.term, this.timestamp);
}

class pantalla_buscar extends StatefulWidget {
  @override
  _pantalla_buscarState createState() => _pantalla_buscarState();
}

class _pantalla_buscarState extends State<pantalla_buscar> {
  List<HistorialItem> elHistorial = [];
  List<dynamic> resultados = []; // Lista para almacenar los resultados de la búsqueda
  TextEditingController _searchController = TextEditingController();
  bool mostrarCategorias = true; // Variable para controlar la visibilidad de las categorías
  Timer? debounce;

  void _onSearchTextChanged() {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      _onSearchSubmitted();
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    debounce?.cancel(); // Cancelar el temporizador si está activo
    super.dispose();
  }

  void _onSearchSubmitted() {
    String searchTerm = _searchController.text;
    if (searchTerm.isNotEmpty) {
      _agregarAlHistorial(searchTerm);
      buscar(searchTerm);
      // Oculta las categorías al realizar la búsqueda
      setState(() {
        mostrarCategorias = false;
      });
    } else {
      setState(() {
        resultados.clear();
        mostrarCategorias = true; // Muestra las categorías si la búsqueda está vacía
      });
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

  void _agregarAlHistorial(String term) {
    setState(() {
      elHistorial.add(HistorialItem(term, DateTime.now()));
    });
  }

  Future<void> buscar(String query) async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/buscar/'), // Reemplaza con la URL de tu API de búsqueda
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'nombre': query,
        }),
      );

      if (response.statusCode == 200) {
        // Procesar la respuesta de la API y mostrar los resultados
        List<dynamic> lista = jsonDecode(response.body);

        setState(() {
          resultados = lista;
        });

        // Aquí puedes mostrar los resultados en tu aplicación de acuerdo a tus necesidades
        //debugPrint('Resultados de la búsqueda: $resultados');
      } else {
        // Mostrar un mensaje de error si la solicitud no fue exitosa
        debugPrint('Error al realizar la búsqueda');
      }
    } catch (e) {
      // Manejar cualquier error que ocurra durante la búsqueda
      debugPrint("Error al realizar la búsqueda: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: TextButton(

          child: const CircleAvatar(
            child: Icon(Icons.person_rounded, color: Colors.white,),
          ),
          onPressed: () {
              Navigator.of(context).push(_createRoute());
          }
        ),
        title: const Row(
          children: [
            Text('Buscar', style: TextStyle(color: Colors.white)),
          ],
        ),
        automaticallyImplyLeading: false, // Eliminar el botón de retroceso predeterminado
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: '¿Qué te apetece escuchar?',
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (query) {
                      buscar(query);
                    },
                  ),
                ),
              ]
            ),

              _buildContent(),
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

  Widget _buildContent() {
    if (mostrarCategorias) {
      return pantalla_categorias();
    } else {
      return resultados.isNotEmpty ? pantalla_busqueda() : const Center(child: CircularProgressIndicator());
    }
  }

  Widget pantalla_busqueda() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: resultados.length,
        itemBuilder: (BuildContext context, int index) {
          Uint8List imagen; // Usarlo para mostrar imagenes pequeñas pero por ahora dejarlo como algo secundario...
          dynamic item = resultados[index];
          String nombre;
          Widget pantallaCorrespondiente;

          if (item.containsKey('cancion')) {
            // como una pantalla de error o una pantalla de detalles genérica.
            nombre = item['cancion']['nombre'];
            pantallaCorrespondiente = PantallaCancion(songId:item['cancion']['id']);
          } else if (item.containsKey('capitulo')) {
            nombre = item['capitulo']['nombre'];
            pantallaCorrespondiente = PantallaCapitulo(capituloId:item['capitulo']['id']);
          } else if (item.containsKey('podcast')) {
            nombre = item['podcast']['nombre'];
            pantallaCorrespondiente = PantallaPodcast(podcastId:item['podcast']['id'], podcastName: item['podcast']['nombre'],);
          } else if (item.containsKey('artista')) {
            nombre = item['artista']['nombre'];
            pantallaCorrespondiente = PantallaArtista(artistaId:item['artista']['id'], artistaName:item['artista']['nombre']);
          } else if (item.containsKey('album')) {
            nombre = item['album']['nombre'];
            pantallaCorrespondiente = Album(albumId:item['album']['id'], albumName:item['album']['nombre']);
          } else if (item.containsKey('presentador')) {
            nombre = item['presentador']['nombre'];
            pantallaCorrespondiente = PantallaPresentador(presentadorId:item['presentador']['id'], presentadorName:item['presentador']['nombre'],);
          } /*else if (item.containsKey('playlist')) {
            nombre = item['playlist']['nombre'];
            pantallaCorrespondiente = Playlist(playlistId:item['playlist']['id'], playlistName: item['playlist']['nombre']);
          } else if (item.containsKey('usuario')) {
            nombre = item['usuario']['nombre'];
            pantallaCorrespondiente = PerfilAjeno(usuario:item);
          } */else {
            // Si no es una canción, podrías asignarle un valor predeterminado,
            // como una pantalla de error o una pantalla de detalles genérica.
            nombre = "Elemento no reconocido";
            pantallaCorrespondiente = pantalla_categorias();
          }

          return GestureDetector(
            onTap: () {
              // Solo intenta navegar si pantallaCorrespondiente no es nulo
              //if (pantallaCorrespondiente != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pantallaCorrespondiente),
                );
              //}
            },
            child: ListTile(
              title: Text(nombre, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          );
        },
      ),
    );
  }



  Widget pantalla_categorias(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Explorar todo',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTopButton('Rap', Colors.blue.shade400),
              buildTopButton('Clasica', Colors.red.shade400),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTopButton('Electro', Colors.green.shade400),
              buildTopButton('Pop', Colors.deepPurple.shade400),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTopButton('Rock', Colors.green.shade900),
              buildTopButton('Reggaeton', Colors.yellow.shade400),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTopButton('Ciencias', Colors.blue.shade400),
              buildTopButton('Cultura', Colors.red.shade400),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTopButton('Ingles', Colors.green.shade400),
              buildTopButton('Psicologia', Colors.deepPurple.shade400),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTopButton('En el coche', Colors.green.shade900),
              buildTopButton('Ejercicio', Colors.yellow.shade400),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTopButton('Relax', Colors.blue.shade400),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildTopButton(String title, Color color) {
    return Container(
      width: 150,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: ElevatedButton(
        onPressed: () {
          if(title == 'Rap') {
            Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => rap()));
          } else if (title == 'Clasica') {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => clasica()));
          } else if (title == 'Electro') {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => electro()));
          } else if (title == 'Pop') {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pop()));
          } else if (title == 'Rock') {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => rock()));
          } else if (title == 'Reggaeton') {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => reggaeton()));
          } else if (title == 'Ciencias') {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ciencias()));
          } else if (title == 'Cultura') {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => cultura()));
          } else if (title == 'Ingles') {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ingles()));
          } else if (title == 'Psicologia') {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => psicologia()));
          } else if (title == 'En el coche') {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => enElCoche()));
          } else if (title == 'Ejercicio') {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ejercicio()));
          } else if (title == 'Relax') {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => relax()));
          }

          // Acción al presionar el botón
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

