import 'package:aversifunciona/biblioteca.dart';
import 'package:aversifunciona/buscar.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/podcast.dart';
import 'package:aversifunciona/salas.dart';
import 'package:aversifunciona/todo.dart';
import 'package:flutter/material.dart';


class pantalla_musica extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Título de la pantalla',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Spacer(),
          CircleAvatar(
            backgroundImage: AssetImage('tu_ruta_de_imagen'),
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
          Spacer(),
          buildOptionsRow("Has escuchado recientemente", 4),
          Spacer(),
          buildOptionsRow("Hecho para user", 4),
          Spacer(),
          buildOptionsRow("Top Canciones", 4),
          Spacer(),
          buildOptionsRow("Top Podcasts", 4),
          Spacer(),
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
                    backgroundColor:Colors.transparent,
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
                    backgroundColor:Colors.transparent,
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
                    backgroundColor:Colors.transparent,
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
                    backgroundColor:Colors.transparent,
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
  Widget buildOptionsRow(String title, int numberOfOptions) {
    return Column(
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            numberOfOptions,
                (index) => buildOption(),
          ),
        ),
      ],
    );
  }

  Widget buildOption() {
    return ElevatedButton(
      onPressed: () {
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      child: Text(
        "",
        style: TextStyle(color: Colors.white),
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



