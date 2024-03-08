import 'package:aversifunciona/pantalla_principal.dart';
import 'package:flutter/material.dart';

import 'biblioteca.dart';
import 'buscar.dart';
import 'chatDeSala.dart';

class pantalla_salas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Salas',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          buildButton('+', Colors.grey, 'Crear sala', () {
            // Navegar a la pantalla de chat cuando se presiona el botón
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDeSala()));
          }),
          buildButton('SpainMusic', Colors.blue, 'Únete ahora', () {
            // Navegar a la pantalla de chat cuando se presiona el botón
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDeSala()));
          }),
          buildButton('SiaLovers', Colors.blue, 'Únete ahora', () {
            // Navegar a la pantalla de chat cuando se presiona el botón
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDeSala()));
          }),
          buildButton('EminemGroup', Colors.blue, 'Únete ahora', () {
            // Navegar a la pantalla de chat cuando se presiona el botón
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDeSala()));
          }),
          SizedBox(height: 20),
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

  Widget buildOption(String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }

  Widget buildButton(String label, Color color, String buttonText, VoidCallback onPressed) {
    return Container(
      width: 300, // Ancho fijo
      height: 100,  // Alto fijo
      margin: EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: onPressed, // Ahora el onPressed es dinámico
        style: ElevatedButton.styleFrom(
          backgroundColor:color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              buttonText,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
