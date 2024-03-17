import 'dart:async';
import 'package:flutter/material.dart';

class reproductor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MusicPlayerScreen(),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool isPlaying = false;
  double progress = 0.0; // Representa la posición de reproducción de la canción
  Timer? timer;

  void togglePlay() {
    setState(() {
      isPlaying = !isPlaying;
      // Simulamos el progreso de la canción
      if (isPlaying) {
        progress = 0.0;
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Now Playing',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            // Agregar aquí la imagen de la canción
            SizedBox(height: 20.0),
            Text(
              'Song Name', // Nombre de la canción actual
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Slider(
              value: progress,
              onChanged: (newValue) {
                setState(() {
                  progress = newValue;
                });
              },
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.skip_previous, color: Colors.white), // Icono blanco
                  iconSize: 64.0,
                  onPressed: previousSong,
                ),
                IconButton(
                  icon: isPlaying ? Icon(Icons.pause, color: Colors.white) : Icon(Icons.play_arrow, color: Colors.white), // Iconos blancos
                  iconSize: 64.0,
                  onPressed: togglePlay,
                ),
                IconButton(
                  icon: Icon(Icons.skip_next, color: Colors.white), // Icono blanco
                  iconSize: 64.0,
                  onPressed: nextSong,
                ),
                IconButton(
                  icon: Icon(Icons.replay, color: Colors.white), // Icono blanco
                  iconSize: 64.0,
                  onPressed: replaySong,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


