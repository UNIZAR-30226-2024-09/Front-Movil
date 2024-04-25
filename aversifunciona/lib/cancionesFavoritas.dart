import 'package:flutter/material.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/salas.dart';

import 'ListaOCarpeta.dart';
import 'biblioteca.dart';
import 'buscar.dart';
import 'chatDeSala.dart';

class cancionesFavoritas extends StatefulWidget {
  @override
  _CancionesFavoritasState createState() => _CancionesFavoritasState();
}

class _CancionesFavoritasState extends State<cancionesFavoritas> {
  String selectedSong = ''; // Estado para almacenar la canción seleccionada

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
                  // Aquí deberías cargar la imagen de la canción
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
          GestureDetector(
            onTap: () {
              // Al hacer clic en la canción, establece la canción seleccionada
              setState(() {
                selectedSong = 'Nombre de la canción';
              });
            },
            child: Row(
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
                    'La cancion',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // Botón a la derecha del nombre de la canción
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: selectedSong.isNotEmpty
          ? Container(
        height: 70,
        color: Colors.grey[900],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                // Acción del botón para reproducir la canción anterior
              },
              icon: Icon(Icons.skip_previous, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                // Acción del botón de reproducción
              },
              icon: Icon(Icons.play_arrow, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                // Acción del botón para reproducir la siguiente canción
              },
              icon: Icon(Icons.skip_next, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                // Acción del botón para reiniciar la canción
              },
              icon: Icon(Icons.replay, color: Colors.white),
            ),
            SizedBox(width: 16),
            Text(
              selectedSong,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      )
          : Container(
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
    );
  }
}
