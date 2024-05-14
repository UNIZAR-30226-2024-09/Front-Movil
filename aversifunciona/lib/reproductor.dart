import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'cancion.dart';
import 'dart:convert';
import 'cancionSin.dart';
import 'capitulo.dart';

import 'env.dart';

class Reproductor extends StatelessWidget {
  var cancion; // Agregar el parámetro cancion
  List<int> ids;
  String playlist;

  Reproductor({required this.cancion, required this.ids, required this.playlist});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reproductor de Música',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MusicPlayerScreen(cancion: cancion, ids: ids, playlist: playlist),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  var cancion; // Agregar el parámetro cancion
  List<int> ids;
  String playlist;
  MusicPlayerScreen({required this.cancion, required this.ids, required this.playlist});
  final player = AudioPlayer();

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState(cancion, player, ids, playlist);
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
  String duracion = '';
  String progreso = '0:00';
  String playlist = '';
  int segundos = 0;
  var posible_podcast;
  var cancion;
  bool podcast = false;
  bool capitulo = false;
  List<dynamic> capitulos = [];
  int index = 0;
  AudioPlayer mp3player = AudioPlayer();
  List<int> ids = [];

  _MusicPlayerScreenState(var song, AudioPlayer player, List<int> index_, String playlist_){
    posible_podcast = song;
    playlist = playlist_;
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

      await mp3player.setAudioSource(
          ConcatenatingAudioSource(children: [
            AudioSource.uri(Uri.dataFromBytes(
              song,
              mimeType: 'audio/mp3',
            ))]));

      setState(() {
        duracion = '${mp3player.duration!.inMinutes}:${mp3player.duration!.inSeconds % 60 >= 10 ? mp3player.duration!.inSeconds %60: '0${mp3player.duration!.inSeconds % 60}'}';
      });

      // Cargar el AudioSource en el reproductor de audio
    }

    catch (e) {
      debugPrint("Error cargando audio base64: $e");
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
          duracion = '${mp3player.duration!.inMinutes}:${mp3player.duration!.inSeconds % 60 >= 10 ? mp3player.duration!.inSeconds %60: '0${mp3player.duration!.inSeconds % 60}'}';
        });

      } else {
        // Handle error or unexpected status code
        throw Exception('Failed to load chapters');
      }

      await mp3player.setAudioSource(
          ConcatenatingAudioSource(children: [
            AudioSource.uri(Uri.dataFromBytes(
              capitulos[0].archivomp3!,
              mimeType: 'audio/mp3',
            ))]));

    }


    catch (e) {
      debugPrint("Error cargando audio base64: $e");
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
          await mp3player.setAudioSource(
              ConcatenatingAudioSource(children: [
                AudioSource.uri(Uri.dataFromBytes(
                  cancion.archivomp3!,
                  mimeType: 'audio/mp3',
                ))]));

          setState(() {
            duracion = '${mp3player.duration!.inMinutes}:${mp3player.duration!.inSeconds % 60 >= 10 ? mp3player.duration!.inSeconds %60: '0${mp3player.duration!.inSeconds % 60}'}';
          });

        }

        catch (e) {
          debugPrint("Error cargando audio base64: $e");
        }

      }
    }
  }

  Future<void> cargar_cancion(var object, List<int> ids, int index) async{
    try {

      await mp3player.setAudioSource(
          ConcatenatingAudioSource(children: [
            AudioSource.uri(Uri.dataFromBytes(
              object.archivomp3!,
              mimeType: 'audio/mp3',
            ))]));

      setState(() {
        duracion = '${mp3player.duration!.inMinutes}:${mp3player.duration!.inSeconds % 60 >= 10 ? mp3player.duration!.inSeconds %60: '0${mp3player.duration!.inSeconds % 60}'}';
      });

    }


    catch (e) {
      debugPrint("Error cargando audio base64: $e");
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
      if (isPlaying) {
        startPlaying();
      } else {
        stopPlaying();
      }
    });
  }

  void startPlaying() async{

    mp3player.play();
    timer?.cancel();
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
          segundos = segundos + 1;
          progreso = '${(segundos / 60).truncate()}:${segundos % 60 >= 10 ? segundos %60: '0${segundos % 60}'}';
          progress += progressIncrement!;
          if(progress >= 1.00){
            progress = 0.00;
            progreso = '0:00';
            nextSong();
          }
        }
      });
    });
  }

  void stopPlaying() async{

    await mp3player.pause();
    timer?.cancel();
    isPlaying = false;
  }

  void nextSong() async{

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
        segundos = 0;
        timer?.cancel();
      }
      else{
        isPlaying = true;
        segundos = 0;
        startPlaying();
      }

    });
  }

  void previousSong() async{

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
      segundos = 0;
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
      segundos = 0;
      startPlaying();
    });
  }

  @override
  void dispose() {

    timer?.cancel();
    mp3player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30.0,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          playlist,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Image.memory(cancion.foto, height: 250, width: 250,),
                const SizedBox(height: 20.0),

                Text(
                  cancion.nombre,
                  style: const TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                const SizedBox(height: 20.0),


                Row(
                  children: [
                    const SizedBox(width: 5,),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: Text(progreso, textAlign: TextAlign.right, style: const TextStyle(color: Colors.white),)),
                    Expanded(
                      child: Slider(
                        activeColor: Colors.white,
                        inactiveColor: Colors.grey,
                        value: progress,
                        onChanged: (newValue) {
                          int secundos = 0;
                          setState(() {
                            progress = newValue;
                            secundos = (newValue * mp3player.duration!.inSeconds.toDouble()).truncate();
                            segundos = secundos;
                            progreso = '${(secundos / 60).truncate()}:${secundos % 60 >= 10 ? secundos %60: '0${secundos % 60}'}';
                            mp3player.seek(Duration

                              (minutes: (secundos / 60).truncate(), seconds: secundos % 60));
                          });
                        },
                      ),
                    ),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 2) , child: Text(duracion, textAlign: TextAlign.left, style: const TextStyle(color: Colors.white),)),
                    const SizedBox(width: 5,),
                  ],
                ),


                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white),
                      iconSize: 55.0,
                      onPressed: previousSong,
                    ),
                    IconButton(
                      icon: isPlaying ? const Icon(Icons.pause, color: Colors.white) : const Icon(Icons.play_arrow, color: Colors.white),
                      iconSize: 55.0,
                      onPressed: togglePlay,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white),
                      iconSize: 55.0,
                      onPressed: nextSong,
                    ),
                    IconButton(
                      icon: const Icon(Icons.replay, color: Colors.white),
                      iconSize: 55.0,
                      onPressed: replaySong,
                    ),
                  ],
                ),

              ],
            ),
          ),

        ],
      ),
      bottomNavigationBar: Container(
        height: 60,

        child: Column(
          children: [
            Center(
              child:
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.volume_mute, color: Colors.white, size: 30.0,),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: Slider(
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
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.white, size: 30.0,),
                      onPressed: () {},
                    ),

                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Letra()),
                        );
                      },
                      child: IconButton(
                        icon: const Icon(Icons.mic_rounded, color: Colors.white, size: 30.0,),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 10),
                  ]
              ),

            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}