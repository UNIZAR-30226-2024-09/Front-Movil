import 'package:aversifunciona/crearSala.dart';
import 'package:flutter/material.dart';

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
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => crearSala()),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.grey, // Color del botón
            ),
            child: Text('+',
              style: TextStyle(
                color: Colors.white, // Color del texto
                fontSize: 18, // Tamaño del texto
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Acción al presionar el primer botón
              print('+');
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // Color del botón
            ),
            child: Text('SpainMusic',
              style: TextStyle(
                color: Colors.white, // Color del texto
                fontSize: 18, // Tamaño del texto
              ),
            ), // Texto del botón
          ),
          ElevatedButton(
            onPressed: () {
              // Acción al presionar el primer botón
              print('+');
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // Color del botón
            ),
            child: Text('SiaLovers',
              style: TextStyle(
                color: Colors.white, // Color del texto
                fontSize: 18, // Tamaño del texto
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Acción al presionar el primer botón
              print('+');
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // Color del botón
            ),
            child: Text('EminemGroup',
              style: TextStyle(
                color: Colors.white, // Color del texto
                fontSize: 18, // Tamaño del texto
              ),
            ),
          ),
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
                buildOption('Inicio'),

                // Opción 2
                buildOption('Buscar'),

                // Opción 3
                buildOption('Biblioteca'),

                // Opción 4
                buildOption('Salas'),
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
        // widget de imagen si es necesario
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }

  Widget buildButton(String label, Color color, IconData icon) {
    return Container(
        width: double.infinity, // Ancho máximo
        height: 100,
      margin: EdgeInsets.all(8),
      child: ElevatedButton.icon(
        onPressed: () {
          // Acción al presionar el botón (puedes personalizarlo según sea necesario)
        },
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

