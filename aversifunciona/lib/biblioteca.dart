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
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('ruta_de_la_imagen'),
                ),
                SizedBox(width: 10),
                Text(
                  'Tu biblioteca',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    // Navegar a la pantalla "crearListaOCarpeta"
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => crearListaOCarpeta()),
                    );
                  },
                  child: Text(
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
                  primary: Colors.transparent,
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
                      child: Image.asset('ruta_de_la_imagen_cuadrado_1'),
                    ),
                    SizedBox(width: 5),
                    Text(
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
                  primary: Colors.transparent,
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
                      child: Image.asset('ruta_de_la_imagen_cuadrado_2'),
                    ),
                    SizedBox(width: 5),
                    Text(
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
                  primary: Colors.transparent,
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
                      child: Image.asset('ruta_de_la_imagen_cuadrado_3'),
                    ),
                    SizedBox(width: 5),
                    Text(
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
                  primary: Colors.transparent,
                  padding: EdgeInsets.all(0), // Sin relleno
                ),
                child: Row(
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
                  primary: Colors.transparent,
                  padding: EdgeInsets.all(0), // Sin relleno
                ),
                child: Row(
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
                    primary: Colors.transparent,
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
                    primary: Colors.transparent,
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
                    primary: Colors.transparent,
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
                    primary: Colors.transparent,
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
          primary: Colors.grey,
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
