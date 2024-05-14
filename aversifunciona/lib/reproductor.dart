import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:base64_audio_source/base64_audio_source.dart';
import 'package:path_provider/path_provider.dart';
import 'cancion.dart';
import 'dart:convert';
import 'cancionSin.dart';
import 'capitulo.dart';

import 'env.dart';

class MyCustomSource extends StreamAudioSource {
  final Uint8List bytes;
  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}

class Reproductor extends StatelessWidget {
  var cancion; // Agregar el parámetro cancion
  List<int> ids;

                    // Create a player
  Reproductor({required this.cancion, required this.ids});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reproductor de Música',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MusicPlayerScreen(cancion: cancion, ids: ids,),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  var cancion; // Agregar el parámetro cancion
  List<int> ids;
  MusicPlayerScreen({required this.cancion, required this.ids});
  final player = AudioPlayer();

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState(cancion, player, ids);
}

class Letra extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Row(children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]),
        backgroundColor: Colors.black,
      ),

    );
  }
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool isPlaying = false;
  double progress = 0.0; // Representa la posición de reproducción de la canción
  double volume = 1.0;
  Timer? timer;
  var posible_podcast;
  var cancion;
  bool podcast = false;
  bool capitulo = false;
  List<dynamic> capitulos = [];
  int index = 0;
  AudioPlayer mp3player = AudioPlayer();
  List<int> ids = [];

  _MusicPlayerScreenState(var song, AudioPlayer player, List<int> index_){
    posible_podcast = song;
    cancion = song;
    mp3player = player;
    if(index_[0] == -33){
      ids = [];
      podcast = true;
    }
    else if (index_[0] == -32){
      ids = [];
      capitulo = true;
    }
    else{
      ids = index_;
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

  Future<void> sig_capitulo(int index) async{

      try {
        // Decodificar el audio base64 a bytes

        Uint8List song = capitulos[index].archivomp3!;
        //song.replaceAll(RegExp('^data:audio\\/mp3;base64,'), '').replaceAll(RegExp('^data:[^;]+;base64,'), '')
        /*String song2 = ('data:audio/mp3;base64,${(utf8.decode(base64Decode(
            song.replaceAll(RegExp(r'^data:audio\/mp3;base64,'), '')
                .replaceAll(
                RegExp(r'^data:[^;]+;base64,'), ''))))}')
            .split(',')
            .last;
        */
        MyCustomSource audioSource = MyCustomSource(capitulos[index].archivomp3!);

        await mp3player.setAudioSource(
            ConcatenatingAudioSource(children: [
              AudioSource.uri(Uri.dataFromBytes(
                song,
                mimeType: 'audio/mp3',
              ))]));

        // Cargar el AudioSource en el reproductor de audio
      }

      catch (e) {
        print("Error cargando audio base64: $e");
      }

  }

  Future<void> cargar_capitulos() async{
    try {
      // Decodificar el audio base64 a bytes

      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarCapitulosPodcast/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'nombrePodcast': cancion.nombre}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        dynamic capitulosData = data['capitulos'];

        List<dynamic> nuevosCapitulos = [];

        for (var i = 0; i < capitulosData.length; i++) {
          Capitulo capitulo = Capitulo.fromJson(capitulosData[i]);
          nuevosCapitulos.add(capitulo);
          debugPrint(capitulo.toString());
        }

        setState(() {
          capitulos = nuevosCapitulos;
        });

      } else {
        // Handle error or unexpected status code
        throw Exception('Failed to load chapters');
      }

      /*
      String song = capitulos[0].archivomp3!;
      //song.replaceAll(RegExp('^data:audio\\/mp3;base64,'), '').replaceAll(RegExp('^data:[^;]+;base64,'), '')
      String song2 = ('data:audio/mp3;base64,${(utf8.decode(base64Decode(
          song.replaceAll(RegExp(r'^data:audio\/mp3;base64,'), '')
              .replaceAll(
              RegExp(r'^data:[^;]+;base64,'), ''))))}')
          .split(',')
          .last;

      // Cargar el archivo temporal en el reproductor de audio
      //await mp3player.setFilePath(tempFile.path);
      MyCustomSource audioSource = MyCustomSource(capitulos[index].archivomp3!);

      */

      await mp3player.setAudioSource(
          ConcatenatingAudioSource(children: [
            AudioSource.uri(Uri.dataFromBytes(
              capitulos[0].archivomp3!,
              mimeType: 'audio/mp3',
            ))]));

      // Cargar el AudioSource en el reproductor de audio
    }


    catch (e) {
      print("Error cargando audio base64: $e");
    }
  }

  Future<void> sig_cancion(List<int> ids, int index) async{
    if (ids.isNotEmpty) {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/devolverCancion/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cancionId': ids[index],
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final utilData = responseData['cancion'];
        debugPrint(responseData.toString());
        CancionSin song_ = CancionSin.fromJson(utilData);

        Uint8List imagen = await _fetchImageFromUrl('${Env.URL_PREFIX}/imagenCancion/${song_.id}/');
        Uint8List audio = await _fetchAudioFromUrl('${Env.URL_PREFIX}/audioCancion/${song_.id}/');

        Cancion song2 = Cancion(id: song_.id, nombre: song_.nombre, miAlbum: song_.miAlbum, puntuacion: song_.puntuacion, archivomp3: audio, foto: imagen);

        setState(() {
          cancion = song2;
        });

        try {
          // Decodificar el audio base64 a bytes

          // String song = cancion.archivomp3!;

          /*
          //song.replaceAll(RegExp('^data:audio\\/mp3;base64,'), '').replaceAll(RegExp('^data:[^;]+;base64,'), '')
          String song2 = ('data:audio/mp3;base64,${(utf8.decode(base64Decode(
              song.replaceAll(RegExp(r'^data:audio\/mp3;base64,'), '')
                  .replaceAll(
                  RegExp(r'^data:[^;]+;base64,'), ''))))}')
              .split(',')
              .last;

          */
          // Cargar el archivo temporal en el reproductor de audio
          //await mp3player.setFilePath(tempFile.path);
          await mp3player.setAudioSource(
              ConcatenatingAudioSource(children: [
                AudioSource.uri(Uri.dataFromBytes(
                  cancion.archivomp3!,
                  mimeType: 'audio/mp3',
                ))]));

          // Cargar el AudioSource en el reproductor de audio
        }

        catch (e) {
          print("Error cargando audio base64: $e");
        }

      }
    }
  }

  Future<void> cargar_cancion(var object, List<int> ids, int index) async{
    try {
      // Decodificar el audio base64 a bytes

      /*
        String song = base64UrlEncode(cancion.archivomp3!);

        String song2 = ('data:audio/mp3;base64,${(utf8.decode(base64Decode(
            song.replaceAll(RegExp(r'^data:audio\/mp3;base64,'), '')
                .replaceAll(
                RegExp(r'^data:[^;]+;base64,'), ''))))}')
            .split(',')
            .last;

        debugPrint(song2);
        */

        // Cargar el archivo temporal en el reproductor de audio
        //await mp3player.setFilePath(tempFile.path);

        //MyCustomSource audioSource = MyCustomSource(base64Decode(song2));

        await mp3player.setAudioSource(
            ConcatenatingAudioSource(children: [
              AudioSource.uri(Uri.dataFromBytes(
                object.archivomp3!,
                mimeType: 'audio/mp3',
        ))]));

        // Cargar el AudioSource en el reproductor de audio
      }


    catch (e) {
      print("Error cargando audio base64: $e");
    }
  }

  @override
  void initState(){
    super.initState();

    if(podcast){
      ids = [];
      cargar_capitulos();
    }
    else if (capitulo){

    }
    else{
      cargar_cancion(cancion, ids, 0);
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

  void startPlaying() async{
    // Cancelar el temporizador anterior si existe
    mp3player.play();
    timer?.cancel();
    // Aquí podrías iniciar la reproducción de la canción
    // Por ahora solo actualizamos el progreso de forma simulada
    double? progressIncrement;
    if (mp3player.duration?.inSeconds == null){
      progressIncrement = 0.01;
    }
    else{
      progressIncrement = 1.0 / mp3player.duration!.inSeconds.toDouble();
    }

    debugPrint(mp3player.duration?.inSeconds.toString());
    const duration = Duration(seconds: 1);
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        if (progress >= 1.0) {
          progress = 0.0;
          stopPlaying();
        } else {
          progress += progressIncrement!;
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

  void nextSong() async{
    // Aquí iría la lógica para avanzar a la siguiente canción
    timer?.cancel();
    bool comienzo = false;
    await mp3player.stop();
    debugPrint(index.toString());

    if(!podcast){
      if (index >= ids.length - 1){
        index = 0;
        comienzo = true;
      }
      else{
        index++;
      }
      await sig_cancion(ids, index);

    }
    else{
      if (index >= capitulos.length - 1){
        index = 0;
        comienzo = true;
      }
      else{
        index++;
      }
      await sig_capitulo(index);
    }

    setState(() {
      progress = 0.0;
      if(comienzo){
        isPlaying = false;
        timer?.cancel();
      }
      else{

        isPlaying = true;
        startPlaying();
      }

    });
  }

  void previousSong() async{
    // Aquí iría la lógica para volver a la canción anterior
    timer?.cancel();
    if (index <= 0){
      index = 0;
      await mp3player.seek(const Duration(minutes: 0 ,seconds: 0));
    }
    else{
      index--;
      await mp3player.stop();
      if(!podcast){
        await sig_cancion(ids, index);
      }
      else{
        await sig_capitulo(index);
      }
    }
    setState(() {
      progress = 0.0;
      isPlaying = true;
      startPlaying();
    });
  }

  void replaySong() async{
    timer?.cancel();
    await mp3player.stop();
    await mp3player.seek(const Duration(minutes: 0 ,seconds: 0));

    setState(() {
      progress = 0.0;
      isPlaying = true;
      startPlaying();
    });
  }

  @override
  void dispose() {
    // Asegurarse de cancelar el temporizador cuando se desmonta el widget
    timer?.cancel();
    mp3player.dispose();
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
                Image.memory(cancion.foto, height: 200, width: 200,),
                const SizedBox(height: 20.0),
                // Agregar aquí la imagen de la canción
                const SizedBox(height: 20.0),

                Text(
                  cancion.nombre, // Nombre de la canción actual
                  style: const TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                const SizedBox(height: 20.0),

                    
                          Row(
                            children: [

                              const Padding(padding: EdgeInsets.symmetric(horizontal: 2), child: Text('x:xx', textAlign: TextAlign.right, style: TextStyle(color: Colors.white),)),
                              Expanded(
                                child: Slider(
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                  value: progress,
                                  onChanged: (newValue) {
                                    setState(() {
                                      progress = newValue;
                                    });
                                  },
                                ),
                              ),
                              const Padding(padding: EdgeInsets.symmetric(horizontal: 2) , child: Text('x:xx', textAlign: TextAlign.left, style: TextStyle(color: Colors.white),)),

                            ],
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
                const SizedBox(height: 20,),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.volume_mute, color: Colors.white,),
                        onPressed: () {},
                      ),
                      Slider(
                        activeColor: Colors.green,
                        inactiveColor: Colors.grey.shade600,
                        thumbColor: Colors.white,
                        value: volume,
                        onChanged: (newValue) {
                          setState(() {
                            volume = newValue;
                            mp3player.setVolume(volume);
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up, color: Colors.white,),
                        onPressed: () {},
                      ),
                      SizedBox(width: 10), // Espacio entre el control de volumen y el nuevo botón
                      GestureDetector( // Envuelve el botón con GestureDetector para manejar la navegación
                        onTap: () {
                          // Navegar a la otra pantalla cuando se presione el botón
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Letra()),
                          );
                        },
                        child: IconButton( // Botón con icono de micrófono
                          icon: const Icon(Icons.mic, color: Colors.white,),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
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


