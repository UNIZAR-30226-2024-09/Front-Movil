import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:base64_audio_source/base64_audio_source.dart';
import 'package:path_provider/path_provider.dart';
import 'package:aversifunciona/getUserSession.dart';
import 'cancion.dart';
import 'dart:convert';
import 'cancionSin.dart';
import 'capitulo.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'env.dart';

class Reproductor extends StatelessWidget {
  var cancion; // Agregar el parámetro cancion
  List<int> ids;
  String playlist;

                    // Create a player
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
      home: MusicPlayerScreen(cancion: cancion, ids: ids, playlist: playlist,),
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


class Letra extends StatefulWidget {
  final String letraPath; // Ruta del archivo de letra
  final AudioPlayer player;

  const Letra({Key? key, required this.letraPath, required this.player}) : super(key: key);

  @override
  _LetraState createState() => _LetraState();
}

class _LetraState extends State<Letra> {
  List<Map<String, dynamic>> letraData = [];
  String currentLine = "";
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _loadLyrics();
    _startLyricsSync();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _loadLyrics() async {
    try {
      final lyricsString = await rootBundle.loadString(widget.letraPath);
      final List<Map<String, dynamic>> parsedLyrics = json.decode(lyricsString).cast<Map<String, dynamic>>();
      setState(() {
        letraData = parsedLyrics;
      });
    } catch (e) {
      print('Error cargando la letra: $e');
    }
  }

  void _startLyricsSync() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      final currentPosition = widget.player.position.inSeconds;

      // Encuentra la línea correspondiente al tiempo actual
      final currentLyricsLine = letraData.lastWhere(
            (line) => line["time"] <= currentPosition,
        orElse: () => {"text": ""},
      );

      setState(() {
        currentLine = currentLyricsLine["text"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                currentLine,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool isPlaying = false;
  bool enCola = false;
  bool hayCola = false;
  double progress = 0.0; // Representa la posición de reproducción de la canción
  double volume = 1.0;
  Timer? timer;
  int id_podcast = 0;
  String duracion = '';
  String progreso = '0:00';
  int segundos = 0;
  var posible_podcast;
  var cancion;
  String playlist = '';
  String _correoS = '';
  bool podcast = false;
  bool capitulo = false;
  String nombrePodcast = '';
  List<dynamic> capitulos = [];
  int index = 0;
  AudioPlayer mp3player = AudioPlayer();
  List<int> ids = [];
  List<dynamic> _cola = [];
  var imagen_cancion;

  _MusicPlayerScreenState(var song, AudioPlayer player, List<int> index_, String playlist_){
    playlist = playlist_;
    posible_podcast = song;
    cancion = song;
    mp3player = player;

    if (index_.isNotEmpty) {
      ids = index_;

      if (index_[0] == -33) {
        debugPrint("Marianela");
        id_podcast = index_[1];
        podcast = true;
      }
      else if (index_[0] == -32) {
        ids = [];
        capitulo = true;
      }
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

  Future<void> _getListarCola() async {
    try {
      String? token = await getUserSession.getToken();
      if (token != null) {
        Map<String, dynamic> userInfo = await getUserSession.getUserInfo(token);
        setState(() {
          _correoS = userInfo['correo'];
        });
        final response = await http.post(
          Uri.parse('${Env.URL_PREFIX}/listarCola/'), // Reemplaza 'tu_url_de_la_api' por la URL correcta
          body: json.encode({'correo': _correoS}),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);

          if (responseData.containsKey('queue') && responseData['queue'] != null) {
            final List<dynamic> colaData = responseData['queue'];
            final List<String> cola = colaData.map((data) => data['nombre'].toString()).toList();

            setState(() {
              hayCola = true;
              _cola = cola;
            });
          } else {
            setState(() {
              hayCola = false;
            });
            print('No se encontraron canciones en la cola de este usuario.');
          }

          setState(() {
            _cola = responseData['queue'];
          });
        } else {
          throw Exception('Error al obtener la cola: ${response.statusCode}');
        }
      } else {
        throw Exception('Error al obtener la cola: ');
      }
    } catch (e) {
      print('Catch: $e');
    }
  }

  void _deleteSongFromQueue(int songId) async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/eliminarCancionCola/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': _correoS,
          'cancionId' : songId,
        }),
      );
      if (response.statusCode == 200) {
        // Eliminación exitosa
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Canción eliminada de la cola'),
          ),
        );
        // Actualizar la lista de canciones después de eliminar la canción
        setState(() {
          _cola = _cola.removeAt(0);
        });
      } else {
        throw Exception('Error al eliminar la canción de la playlist');
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al eliminar la canción de la playlist'),
        ),
      );
    }
  }

  Future<void> sig_capitulo(int index) async{

      try {
        // Decodificar el audio base64 a bytes

        Uint8List audio = await _fetchAudioFromUrl('${Env.URL_PREFIX}/audioPodcast/${ids[index]}/');
        //song.replaceAll(RegExp('^data:audio\\/mp3;base64,'), '').replaceAll(RegExp('^data:[^;]+;base64,'), '')
        /*String song2 = ('data:audio/mp3;base64,${(utf8.decode(base64Decode(
            song.replaceAll(RegExp(r'^data:audio\/mp3;base64,'), '')
                .replaceAll(
                RegExp(r'^data:[^;]+;base64,'), ''))))}')
            .split(',')
            .last;
        */

        await mp3player.setAudioSource(
            ConcatenatingAudioSource(children: [
              AudioSource.uri(Uri.dataFromBytes(
                audio,
                mimeType: 'audio/mp3',
              ))]));

        setState(() {
          duracion = '${mp3player.duration!.inMinutes}:${mp3player.duration!.inSeconds % 60 >= 10 ? mp3player.duration!.inSeconds %60: '0${mp3player.duration!.inSeconds % 60}'}';
        });

        // Cargar el AudioSource en el reproductor de audio
      }

      catch (e) {
        print("Error cargando audio base64: $e");
      }

  }

  Future<void> cargar_capitulos(int index) async{
    try {
      // Decodificar el audio base64 a bytes
      imagen_cancion = await _fetchImageFromUrl('${Env.URL_PREFIX}/imagenPodcast/$id_podcast/');

      final response2 = await http.post(
        Uri.parse('${Env.URL_PREFIX}/devolverPodcast/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'podcastId': id_podcast}),
      );

      if (response2.statusCode == 200){
        Map<String, dynamic> data = jsonDecode(response2.body);
        dynamic name = data['podcast'];
        nombrePodcast = name['nombre'];
      }


      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarCapitulosPodcast/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'nombrePodcast': nombrePodcast}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        dynamic capitulosData = data['capitulos'];

        List<int> nuevosCapitulos = [];

        for (var i = 0; i < capitulosData.length; i++) {
          Capitulo capitulo = Capitulo.fromJson(capitulosData[i]);

          nuevosCapitulos.add(capitulo.id!);
        }

        debugPrint(nuevosCapitulos.toString());
        setState(() {
          ids = nuevosCapitulos;
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
      debugPrint("Pedro");
      Uint8List audio = await _fetchAudioFromUrl('${Env.URL_PREFIX}/audioPodcast/${ids[0]}/');


      await mp3player.setAudioSource(
          ConcatenatingAudioSource(children: [
            AudioSource.uri(Uri.dataFromBytes(
              audio,
              mimeType: 'audio/mp3',
            ))]));

      setState(() {
        duracion = '${mp3player.duration!.inMinutes}:${mp3player.duration!.inSeconds % 60 >= 10 ? mp3player.duration!.inSeconds %60: '0${mp3player.duration!.inSeconds % 60}'}';
      });
      // Cargar el AudioSource en el reproductor de audio
    }


    catch (e) {
      print("Error cargando audio base64: $e");
    }
  }

  Future<void> sig_cancion(List<int> ids, int index) async{

    String? token = await getUserSession.getToken();
    if (token != null) {
      Map<String, dynamic> userInfo = await getUserSession.getUserInfo(token);
      setState(() {
        _correoS = userInfo['correo'];
      });
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/agnadirCancionHistorial/'), // Reemplaza 'tu_url_de_la_api' por la URL correcta
        body: json.encode({'correo': _correoS, 'cancionId': ids[index]}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {

      }
      else {
        throw Exception('Error al obtener la cola: ${response.statusCode}');
      }
    }

    if (ids.length > 1) {
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
          imagen_cancion = imagen;
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

          setState(() {
            duracion = '${mp3player.duration!.inMinutes}:${mp3player.duration!.inSeconds % 60 >= 10 ? mp3player.duration!.inSeconds %60: '0${mp3player.duration!.inSeconds % 60}'}';
          });

          // Cargar el AudioSource en el reproductor de audio
        }

        catch (e) {
          print("Error cargando audio base64: $e");
        }

      }
    }
  }

  Future<void> cargar_cancion(var object, List<int> ids, int index) async{
    debugPrint(ids.toString());
    String? token = await getUserSession.getToken();
    if (token != null) {
      Map<String, dynamic> userInfo = await getUserSession.getUserInfo(token);
      setState(() {
        _correoS = userInfo['correo'];
      });
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/agnadirCancionHistorial/'), // Reemplaza 'tu_url_de_la_api' por la URL correcta
        body: json.encode({'correo': _correoS, 'cancionId': ids[index]}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        debugPrint("Pedro");
      }
      else {
        throw Exception('Error al obtener la cola: ${response.statusCode}');
      }
    }

    Uint8List imagen = await _fetchImageFromUrl('${Env.URL_PREFIX}/imagenCancion/${cancion.id}/');
    setState(() {
      imagen_cancion = imagen;
    });

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


        setState(() {
          duracion = '${mp3player.duration!.inMinutes}:${mp3player.duration!.inSeconds % 60 >= 10 ? mp3player.duration!.inSeconds %60: '0${mp3player.duration!.inSeconds % 60}'}';
        });

        // Cargar el AudioSource en el reproductor de audio
      }


    catch (e) {
      print("Error cargando audio base64: $e");
    }
  }

  @override
  void initState(){
    _getListarCola();
    if(podcast){
      cargar_capitulos(0);
    }
    else if (capitulo){

    }
    else{
      cargar_cancion(cancion, ids, 0);
    }
    super.initState();
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

        if (!podcast) { // No es un podcast
          if (index >= ids.length - 1) {
            index = 0;
            comienzo = true;
          }
          else {
            index++;
          }
          await sig_cancion(ids, index);
        }
        else { // Es un podcast
          debugPrint(ids.length.toString());
          if (index >= ids.length - 1) {
            index = 0;
            comienzo = true;
          }
          else {
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
    // Aquí iría la lógica para volver a la canción anterior
    timer?.cancel();
      if (index <= 0){
        index = 0;
        await mp3player.stop();
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
    // Asegurarse de cancelar el temporizador cuando se desmonta el widget
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
                imagen_cancion !=null ? Image.memory(imagen_cancion, height: 200, width: 200,) : const CircularProgressIndicator(),
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

                              Padding(padding: const EdgeInsets.symmetric(horizontal: 2), child: Text(progreso, textAlign: TextAlign.right, style: TextStyle(color: Colors.white),)),
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
                                      mp3player.seek(Duration(minutes: (secundos / 60).truncate(), seconds: secundos % 60));
                                    });
                                  },
                                ),
                              ),
                              Padding(padding: const EdgeInsets.symmetric(horizontal: 2) , child: Text(duracion, textAlign: TextAlign.left, style: TextStyle(color: Colors.white),)),

                            ],
                          ),


                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white), // Icono blanco
                      iconSize: 55.0,
                      onPressed: previousSong,
                    ),
                    IconButton(
                      icon: isPlaying ? const Icon(Icons.pause, color: Colors.white) : const Icon(Icons.play_arrow, color: Colors.white), // Iconos blancos
                      iconSize: 55.0,
                      onPressed: togglePlay,
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white), // Icono blanco
                      iconSize: 55.0,
                      onPressed: nextSong,
                    ),
                    IconButton(
                      icon: const Icon(Icons.replay, color: Colors.white), // Icono blanco
                      iconSize: 55.0,
                      onPressed: replaySong,
                    ),
                  ],
                ),
                const SizedBox(height: 20,),

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.volume_mute, color: Colors.white, size: 30.0,),
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
                    icon: const Icon(Icons.volume_up, color: Colors.white, size: 30.0,),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10), // Espacio entre el control de volumen y el nuevo botón
                  IconButton(
                    icon: const Icon(Icons.mic, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Letra(
                            letraPath: 'lib/letras/${cancion.id}.js',
                            player: mp3player,
                          ),
                        ),
                      );
                    },
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


