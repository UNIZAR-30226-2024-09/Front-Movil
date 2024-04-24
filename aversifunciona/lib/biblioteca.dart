import 'package:aversifunciona/cancionesFavoritas.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/salas.dart';
import 'package:flutter/material.dart';
import 'package:aversifunciona/verPerfil.dart';

import 'configuracion.dart';
import 'historial.dart';
import 'buscar.dart';

class pantalla_biblioteca extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        backgroundColor: Colors.black,

          leading: PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundImage: AssetImage('tu_ruta_de_imagen'),
            ),
            onSelected: (value) {
              // Manejar la selección del desplegable
              if (value == 'verPerfil') {
                // Navegar a la pantalla "verPerfil"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => verPerfil()),
                );
              } else if (value == 'historial') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => historial()),
                );
              } else if (value == 'configuracion') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => configuracion()),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'verPerfil',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Ver Perfil'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'historial',
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Historial'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'configuracion',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Configuración y Privacidad'),
                ),
              ),
            ],
          ),
        title: const Text(
          'Tu biblioteca',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [

          const Text(
            '+  ',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ]
      ),
      body: Column(
        children: [
          // Sección 1

          Expanded(
            child: Container(
              child: ListView(
                children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    // Botón con imagen y texto
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => cancionesFavoritas()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.transparent,
                        padding: const EdgeInsets.all(0), // Sin relleno
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40, // Ajusta el tamaño según sea necesario
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey, // Puedes ajustar el color del cuadrado
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.heart_broken, color: Colors.white),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Canciones que te gustan',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Sección 2
                Row(
                  children: [
                    // Botón con imagen y texto
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => cancionesFavoritas()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.transparent,
                        padding: EdgeInsets.all(0), // Sin relleno
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40, // Ajusta el tamaño según sea necesario
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey, // Puedes ajustar el color del cuadrado
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.music_note, color: Colors.grey.shade800),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Playlist Nº1',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Sección 3
                Row(
                  children: [
                    // Botón con imagen y texto
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => cancionesFavoritas()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.transparent,
                        padding: EdgeInsets.all(0), // Sin relleno
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40, // Ajusta el tamaño según sea necesario
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey, // Puedes ajustar el color del cuadrado
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.music_note, color: Colors.grey.shade800),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'Playlist Nº2',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Sección 4
                Row(
                  children: [
                    // Botón con imagen y texto
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => cancionesFavoritas()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.transparent,
                        padding: EdgeInsets.all(0), // Sin relleno
                      ),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage('ruta_de_la_imagen'),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Añadir artistas',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Botón con imagen y texto
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => cancionesFavoritas()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.transparent,
                        padding: EdgeInsets.all(0), // Sin relleno
                      ),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage('ruta_de_la_imagen'),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Añadir podcast',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ]
              ),

            ),
          ),
          Container(
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
                    backgroundColor:Colors.transparent,
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
                      ]
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
                    backgroundColor:Colors.transparent,
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
                      ]
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
                    backgroundColor:Colors.transparent,
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
                      ]
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
                    backgroundColor:Colors.transparent,
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
                      ]
                  ),
                ),
              ],
            ),

          ),
        ],
      ),
    );
  }

  Widget buildOption(String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Aquí puedes agregar tu propio widget de imagen si es necesario
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }

  Widget buildTopButton(String title) {
    return Container(
      margin: EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () {
          // Acción al presionar el botón (puedes personalizarlo según sea necesario)
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:Colors.grey,
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
