import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'salas.dart';
import 'musica.dart';
import 'todo.dart';
import 'podcast.dart';
import 'biblioteca.dart';
import 'buscar.dart';
import 'historial.dart';
import 'verPerfil.dart';
import 'configuracion.dart';
import 'cancion.dart';
import 'env.dart';
import 'reproductor.dart';

Future<List<Cancion>> conseguir_canciones() async {
  try {
    final response = await http.get(
      Uri.parse("${Env.URL_PREFIX}/listarCanciones/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    var lista = jsonDecode(response.body);
    List<Cancion> canciones = [];

    for (var indice in lista) {
      Cancion cancion = Cancion(
        nombre: indice["nombre"],
        miAlbum: indice["miAlbum"],
        puntuacion: indice["puntuacion"],
        numPuntuaciones: indice["numPuntuaciones"],
        archivo_mp3: indice["archivo_mp3"],
        foto: indice["foto"],
      );
      canciones.add(cancion);
    }

    if (response.statusCode == 200) {
      // Si la solicitud es exitosa, retornar verdadero
      return canciones;
    } else {
      print("Error" + (response.statusCode).toString());
      // Si la solicitud no es exitosa, retornar falso
      return [];
    }
  } catch (e) {
    // Si ocurre algún error, retornar falso
    print("Error al realizar la solicitud HTTP: $e");
    return [];
  }
}

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

class pantalla_opciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Row(children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ]),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: ListView(
                children: [
                  Container(
                    height: 125,
                    child: TextButton(
                      child: Text(
                        'Ver perfil',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => verPerfil()),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 125,
                    child: TextButton(
                      child: Text(
                        'Historial',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => historial()),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 125,
                    child: TextButton(
                      child: Text(
                        'Configuración y privacidad',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => configuracion()),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Función de manejo de tap
/*void handleTap(BuildContext context, Cancion cancion) {
  // Aquí puedes manejar la acción de tap con la canción específica
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => reproductor()), // cancion: cancion dentro de reproductor cuando esto funcione
  );
}*/

class pantalla_principal extends StatefulWidget {
  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<pantalla_principal> {
  Cancion? _selectedSong; // Canción seleccionada inicializada a null
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: TextButton(
          child: CircleAvatar(
            backgroundImage: AssetImage('tu_ruta_de_imagen'),
          ),
          onPressed: () {
            Navigator.of(context).push(_createRoute());
          }
        ),
        title: const Text(
          'Título de la pantalla',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Spacer(),
          buildTopButton(context, 'Todo', pantalla_todo()),
          buildTopButton(context, 'Música', pantalla_musica()),
          buildTopButton(context, 'Podcast', pantalla_podcast()),
        ],
      ),
      body: FutureBuilder<List<Cancion>>(
        future: conseguir_canciones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Cancion> canciones = snapshot.data ?? [];
            return ListView.builder(
              itemCount: canciones.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    //handleTap(context, canciones[index]);
                    setState(() { // asi podemos mantener el estado de la cancion
                      _selectedSong = canciones[index];
                    });
                    // Aquí puedes manejar el tap según tus necesidades
                  },
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        '    Has escuchado recientemente',
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        height: 125,
                        width: 350,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // Aquí deberías colocar tu código para mostrar las canciones recientes

                                Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Image.memory(
                                    base64Decode(canciones[index].foto),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 8), // Espacio entre contenedores
                            ],
                          ),
                        ),
                      ),
                      Text(
                        '    Hecho para el usuario',
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        height: 125,
                        width: 350,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // Aquí deberías colocar tu código para mostrar las canciones personalizadas
                              Container(
                                height: 75,
                                width: 75,
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                child: Image.memory(
                                  base64Decode(canciones[index].foto),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 8), // Espacio entre contenedores
                            ],
                          ),
                        ),
                      ),
                      Text(
                        '    Top Canciones',
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        height: 125,
                        width: 350,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // Aquí deberías colocar tu código para mostrar las canciones principales
                              Container(
                                height: 75,
                                width: 75,
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                child: Image.memory(
                                  base64Decode(canciones[index].foto),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 8), // Espacio entre contenedores
                            ],
                          ),
                        ),
                      ),
                      Text(
                        '    Top Podcasts',
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        height: 125,
                        width: 350,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // Aquí deberías colocar tu código para mostrar los podcasts principales
                              Container(
                                height: 75,
                                width: 75,
                                margin: const EdgeInsets.symmetric(horizontal: 16),
                                child: Image.memory(
                                  base64Decode(canciones[index].foto),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _selectedSong != null
              ? Container(
            height: 70,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.white),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _selectedSong?.nombre ?? '',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => reproductor(cancion: _selectedSong)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    //primary: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Reproducir',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          )
              : Container(), // Asegura que siempre haya un widget para evitar errores de diseño
          Container(
            height: 70,
            decoration: BoxDecoration(
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
        ],
      )
    );
  }

  Widget buildOption(String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }

  Widget buildTopButton(BuildContext context, String title, Widget screen) {
    return Container(
      margin: EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => reproductor()),
          );*/
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}