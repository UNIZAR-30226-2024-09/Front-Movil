import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'cancion.dart';
import 'dart:convert';

class reproductor extends StatelessWidget {
  final Cancion cancion; // Agregar el parámetro cancion
                    // Create a player
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
  final player = AudioPlayer();

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState(cancion, player);
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool isPlaying = false;
  double progress = 0.0; // Representa la posición de reproducción de la canción
  Timer? timer;
  Cancion cancion = const Cancion(id: 0, nombre: '', miAlbum: 0, puntuacion: 0, archivomp3: '', foto: '');
  AudioPlayer mp3player = AudioPlayer();

  _MusicPlayerScreenState(Cancion song, AudioPlayer player){
    cancion = song;
    mp3player = player;
  }

  Future<void> cargar_cancion() async{
    try {
      // Decodificar el audio base64 a bytes
      String song = cancion.archivomp3!;
      //song.replaceAll(RegExp('^data:audio\\/mp3;base64,'), '').replaceAll(RegExp('^data:[^;]+;base64,'), '')
      List<int> bytes = base64Decode(song.replaceAll(RegExp('^data:audio\\/mp3;base64,'), '').replaceAll(RegExp('^data:[^;]+;base64,'), ''));
      String base64decoded = utf8.decode(bytes);
      bytes = base64Decode(base64decoded);
      // Obtener el directorio temporal para guardar el archivo
      Directory tempDir = await getTemporaryDirectory();

      // Crear un archivo temporal para el audio
      File tempFile = File('${tempDir.path}/temp_audio.mp3');

      // Escribir los bytes en el archivo temporal en fragmentos
      final bufferSize = 4096;
      var buffer = BytesBuilder();
      for (var i = 0; i < bytes.length; i += bufferSize) {
        var end = (i + bufferSize < bytes.length) ? i + bufferSize : bytes.length;
        buffer.add(bytes.sublist(i, end));
        await tempFile.writeAsBytes(buffer.toBytes(), mode: FileMode.append, flush: true);
        buffer.clear();
      }

      // Cargar el archivo temporal en el reproductor de audio
      await mp3player.setFilePath(tempFile.path);

      // Cargar el AudioSource en el reproductor de audio
    }
    catch (e) {
      print("Error cargando audio base64: $e");
    }
  }

  @override
  void initState(){
    super.initState();
    cargar_cancion();
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

  void startPlaying() async{
    // Cancelar el temporizador anterior si existe
    await mp3player.play();
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

  void stopPlaying() async{
    // Detener el temporizador si existe
    await mp3player.pause();
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


