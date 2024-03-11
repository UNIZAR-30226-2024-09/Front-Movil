import 'package:aversifunciona/biblioteca.dart';
import 'package:aversifunciona/buscar.dart';
import 'package:aversifunciona/configuracion.dart';
import 'package:aversifunciona/desplegable.dart';
import 'package:aversifunciona/podcast.dart';
import 'package:aversifunciona/salas.dart';
import 'package:aversifunciona/todo.dart';
import 'package:flutter/material.dart';

import 'musica.dart';

class pantalla_principal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            // Navegar a la pantalla deseada al hacer clic en CircleAvatar
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => desplegable()),
            );
          },
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.grey),
          ),
        ),
        title: Text(
          'Título de la pantalla',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Spacer(),

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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => pantalla_principal()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Inicio',
                    style: TextStyle(color: Colors.white, fontSize: 12),
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
                    backgroundColor:Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Buscar',
                    style: TextStyle(color: Colors.white, fontSize: 12),
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
                    backgroundColor:Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Biblioteca',
                    style: TextStyle(color: Colors.white, fontSize: 12),
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
                    backgroundColor:Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Salas',
                    style: TextStyle(color: Colors.white, fontSize: 12),
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
          style: TextStyle(color: Colors.white, fontSize: 18), // Ajusta el tamaño de la fuente según sea necesario
        ),
      ],
    );
  }

  Widget buildTopButton(BuildContext context, String title, Widget screen) {
    return Container(
      margin: EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () {
          // Navegar a la pantalla correspondiente
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
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




