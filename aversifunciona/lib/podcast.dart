import 'package:aversifunciona/biblioteca.dart';
import 'package:aversifunciona/buscar.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/salas.dart';
import 'package:flutter/material.dart';

class pantalla_podcast extends StatelessWidget {
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
          buildTopButton('Todo'),

          // Botón Música
          buildTopButton('Música'),

          // Botón Podcast
          buildTopButton('Podcast'),
        ],
      ),
      body: Column(
        children: [
          // Botón con imagen 1
          ElevatedButton(
            onPressed: () {
              // escuchar podcast
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Container(
              height: 150,
              width: 200,
              child: Image.asset('imagen_podcast', fit: BoxFit.cover),
            ),
          ),
          Spacer(),
          // Botón con imagen 2
          ElevatedButton(
            onPressed: () {
              // escuchar podcast
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Container(
              height: 150,
              width: 200,
              child: Image.asset('imagen_podcast', fit: BoxFit.cover),
            ),
          ),
          Spacer(),
          // Botón con imagen 3
          ElevatedButton(
            onPressed: () {
              // escuchar podcast
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Container(
              height: 150,
              width: 200,
              child: Image.asset('imagen_podcast', fit: BoxFit.cover),
            ),
          ),
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
          style: TextStyle(color: Colors.white, fontSize: 18), // Ajusta el tamaño de la fuente según sea necesario
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

class SalasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salas'),
      ),
      body: Center(
        child: Text('Contenido de la pantalla Salas'),
      ),
    );
  }
}

