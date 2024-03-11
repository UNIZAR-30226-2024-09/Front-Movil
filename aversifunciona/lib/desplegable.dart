import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/podcast.dart';
import 'package:aversifunciona/todo.dart';
import 'package:aversifunciona/verPerfil.dart';
import 'package:flutter/material.dart';

import 'biblioteca.dart';
import 'buscar.dart';
import 'chatDeSala.dart';
import 'configuracion.dart';
import 'historial.dart';
import 'musica.dart';

class desplegable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          // Desplegable con foto de perfil, nombre y opciones
          PopupMenuButton<String>(
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
          Spacer(),
          // Botón Todo
          buildTopButton(context, 'Todo', pantalla_todo()),

          // Botón Música
          buildTopButton(context, 'Música', pantalla_musica()),

          // Botón Podcast
          buildTopButton(context, 'Podcast', pantalla_podcast()),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // Contenido principal (puedes colocar aquí tu imagen o cualquier otro contenido)
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.white),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Opción 1
                ElevatedButton(
                  onPressed: () {
                    // Navegar a la pantalla "Inicio"
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
                  child: Text(
                    'Inicio',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // Opción 2
                ElevatedButton(
                  onPressed: () {
                    // Navegar a la pantalla "Buscar"
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
                  child: Text(
                    'Buscar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // Opción 3
                ElevatedButton(
                  onPressed: () {
                    // Navegar a la pantalla "Biblioteca"
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
                  child: Text(
                    'Biblioteca',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // Opción 4
                ElevatedButton(
                  onPressed: () {
                    // Navegar a la pantalla "Salas"
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
                  child: Text(
                    'Salas',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopButton(BuildContext context, String title, Widget screen) {
    return Container(
      margin: EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () {
          // Navegar a la pantalla correspondiente
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
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

