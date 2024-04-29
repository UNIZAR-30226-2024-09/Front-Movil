import 'dart:async';
import 'package:flutter/material.dart';

import 'cancion.dart';

class reproductor extends StatelessWidget {
  final Cancion cancion; // Agregar el parámetro cancion
  reproductor({required this.cancion});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reproductor de Música',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MusicPlayerScreen(cancion: cancion),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  final Cancion cancion; // Agregar el parámetro cancion
  MusicPlayerScreen({required this.cancion});
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState(cancion);
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool isPlaying = false;
  double progress = 0.0; // Representa la posición de reproducción de la canción
  Timer? timer;
  Cancion cancion = const Cancion(id: 0, nombre: '', miAlbum: 0, puntuacion: 0, archivomp3: '', foto: '');

  _MusicPlayerScreenState(Cancion song){
    cancion = song;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Now Playing',
                  style: TextStyle(fontSize: 24.0),
                ),
                const SizedBox(height: 20.0),
                // Agregar aquí la imagen de la canción
                const SizedBox(height: 20.0),

                Text(
                  cancion.nombre, // Nombre de la canción actual
                  style: const TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                const SizedBox(height: 20.0),
                Slider(
                  value: progress,
                  onChanged: (newValue) {
                    setState(() {
                      progress = newValue;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white), // Icono blanco
                      iconSize: 64.0,
                      onPressed: previousSong,
                    ),
                    IconButton(
                      icon: isPlaying ? const Icon(Icons.pause, color: Colors.white) : const Icon(Icons.play_arrow, color: Colors.white), // Iconos blancos
                      iconSize: 64.0,
                      onPressed: togglePlay,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white), // Icono blanco
                      iconSize: 64.0,
                      onPressed: nextSong,
                    ),
                    IconButton(
                      icon: const Icon(Icons.replay, color: Colors.white), // Icono blanco
                      iconSize: 64.0,
                      onPressed: replaySong,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                const Text(
                  'Nombre de la Playlist',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


