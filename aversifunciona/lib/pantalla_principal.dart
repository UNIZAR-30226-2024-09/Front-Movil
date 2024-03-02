import 'package:aversifunciona/salas.dart';
import 'package:flutter/material.dart';

class pantalla_principal extends StatelessWidget {
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

