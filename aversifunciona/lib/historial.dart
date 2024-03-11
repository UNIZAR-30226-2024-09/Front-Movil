import 'package:aversifunciona/biblioteca.dart';
import 'package:aversifunciona/buscar.dart';
import 'package:aversifunciona/chatDeSala.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:flutter/material.dart';

class historial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Volver a la pantalla anterior
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Historial',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Spacer(),
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
