import 'package:aversifunciona/cancionesFavoritas.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:flutter/material.dart';

import 'ListaOCarpeta.dart';
import 'buscar.dart';
import 'chatDeSala.dart';

class pantalla_biblioteca extends StatelessWidget {
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
                const CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.person, color: Colors.grey),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Tu biblioteca',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // Navegar a la pantalla "crearListaOCarpeta"
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => crearListaOCarpeta()),
                    );
                  },
                  child: const Text(
                    '+',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          // Sección 1
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
                      child: Icon(Icons.heart_broken, color: Colors.white),
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
          Expanded(
            child: Container(
              // Contenido principal (puedes colocar aquí tu imagen o cualquier otro contenido)
            ),
          ),
          Container(
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
