import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/salas.dart';
import 'package:flutter/material.dart';

import 'ListaOCarpeta.dart';
import 'biblioteca.dart';
import 'buscar.dart';
import 'chatDeSala.dart';


class cancionesFavoritas extends StatefulWidget {
  @override
  _cancionesFavoritasState createState() => _cancionesFavoritasState();
}

class _cancionesFavoritasState extends State<cancionesFavoritas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('ruta_de_la_imagen'),
                ),
                SizedBox(width: 10),
                Text(
                  'Tu biblioteca',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cuadrado con la imagen
              Container(
                width: 40, // Ajusta el tamaño según sea necesario
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey, // Puedes ajustar el color del cuadrado
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset('ruta_de_la_imagen_cuadrado'), //imagen de la cancion
              ),
              SizedBox(width: 10), // Espacio entre la imagen y el nombre de la canción
              // Nombre de la canción
              Expanded(
                child: Text(
                  'Nombre de la canción',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              // Botón a la derecha del nombre de la canción
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => cancionesFavoritas()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'Canciones que te gustan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              // Contenido principal (puedes colocar aquí tu imagen o cualquier otro contenido)
            ),
          ),
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
      ),
    );
  }
}
