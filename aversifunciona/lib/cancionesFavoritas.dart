import 'dart:async';
import 'dart:convert';
import 'package:aversifunciona/reproductor.dart';
import 'package:flutter/material.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/salas.dart';
import 'biblioteca.dart';
import 'buscar.dart';
import 'cancion.dart';
import 'package:http/http.dart' as http;


class cancionesFavoritas extends StatefulWidget {
  @override
  _CancionesFavoritasState createState() => _CancionesFavoritasState();
}

class _CancionesFavoritasState extends State<cancionesFavoritas> {
  List<Cancion> canciones = []; // Lista para almacenar las canciones
  Cancion? selectedSong; // Canción seleccionada

  bool isPlaying = false;
  double progress = 0.0; // Representa la posición de reproducción de la canción
  Timer? timer;
  @override
  void initState() {
    super.initState();
    // Llama a la función para cargar las canciones al inicializar el widget
    loadSongs();
  }

  Future<void> loadSongs() async {
    try {
      final response = await http.get(
        Uri.parse("<URL_de_tu_endpoint_para_obtener_canciones>"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      if (response.statusCode == 200) {
        var lista = jsonDecode(response.body);
        List<Cancion> fetchedSongs = [];

        for (var indice in lista) {
          /*Cancion cancion = Cancion(
            nombre: indice["nombre"],
            foto: indice["foto"],
          );
          fetchedSongs.add(cancion);*/
        }

        setState(() {
          canciones = fetchedSongs;
        });
      } else {
        print("Error" + (response.statusCode).toString());
      }
    } catch (e) {
      print("Error al realizar la solicitud HTTP: $e");
    }
  }


  void togglePlay() {
    setState(() {
      isPlaying = !isPlaying;
      // Simulamos el progreso de la canción
      if (isPlaying) {
        startPlaying();
      } else {
        stopPlaying();
      }
    });
  }

  void startPlaying() {
    // Cancelar el temporizador anterior si existe
    timer?.cancel();
    // Aquí podrías iniciar la reproducción de la canción
    // Por ahora solo actualizamos el progreso de forma simulada
    const progressIncrement = 0.01;
    const duration = Duration(seconds: 1);
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        if (progress >= 1.0) {
          progress = 0.0;
          stopPlaying();
        } else {
          progress += progressIncrement;
        }
      });
    });
  }

  void stopPlaying() {
    // Detener el temporizador si existe
    timer?.cancel();
    isPlaying = false;
  }

  void nextSong() {
    // Aquí iría la lógica para avanzar a la siguiente canción
  }

  void previousSong() {
    // Aquí iría la lógica para volver a la canción anterior
  }

  void replaySong() {
    setState(() {
      progress = 0.0;
      startPlaying();
      isPlaying = true;
    });
  }

  @override
  void dispose() {
    // Asegurarse de cancelar el temporizador cuando se desmonta el widget
    timer?.cancel();
    super.dispose();
  }

  void goToReproductor() {
    // Aquí iría la lógica para dirigirse a la pantalla del reproductor
    // junto con los datos de la canción para seguir reproduciendo
    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => reproductor(cancion: selectedSong),
      ),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey, // Puedes ajustar el color del cuadrado
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset('ruta_de_la_imagen_cuadrado'), //imagen de la cancion
                ),
                SizedBox(width: 10),
                Text(
                  'Tu biblioteca',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Al hacer clic en la canción, establece la canción seleccionada
              setState(() {
                //selectedSong = canciones[index];
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cuadrado con la imagen
                Container(
                  width: 40, // Ajusta el tamaño según sea necesario
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey, // Puedes ajustar el color del cuadrado
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset('ruta_de_la_imagen_cuadrado'), //imagen de la cancion
                ),
                SizedBox(width: 10), // Espacio entre la imagen y el nombre de la canción
                // Nombre de la canción
                Expanded(
                  child: Text(
                    'La cancion',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // Botón a la derecha del nombre de la canción
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: selectedSong != null
          ? Container(
        height: 150,
        color: Colors.grey[900],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Contenedor para la imagen y el nombre de la canción
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  // Imagen de la canción

                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey, // Puedes ajustar el color del cuadrado
                      borderRadius: BorderRadius.circular(8),

                    ),
                    child: Image.asset('ruta_de_la_imagen_cuadrado'), //imagen de la cancion
                  ),
                  SizedBox(width: 10),
                  // Nombre de la canción
                  /*Text(
                    selectedSong.nombre,
                    style: TextStyle(color: Colors.white),
                  ),*/
                ],
              ),
            ),
            // Iconos de reproducción y barra de progreso
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Iconos de reproducción
                Row(
                  children: [
                    IconButton(
                      onPressed: previousSong,
                      icon: Icon(Icons.skip_previous, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: togglePlay,
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: nextSong,
                      icon: Icon(Icons.skip_next, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: replaySong,
                      icon: Icon(Icons.replay, color: Colors.white),
                    ),
                  ],
                ),
                // Barra de progreso
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Slider(
                        value: progress,
                        onChanged: (newValue) {
                          setState(() {
                            progress = newValue;
                          });
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )
          : Container(
        height: 70,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.white),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Botones de navegación
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pantalla_principal()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Column(
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
                  MaterialPageRoute(builder: (context) => pantalla_buscar()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Column(
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
                  MaterialPageRoute(builder: (context) => pantalla_biblioteca()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Column(
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
                  MaterialPageRoute(builder: (context) => pantalla_salas()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Column(
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


