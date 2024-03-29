import 'package:aversifunciona/crearSala.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:flutter/material.dart';
import 'package:aversifunciona/verPerfil.dart';

import 'configuracion.dart';
import 'historial.dart';
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
        leading: PopupMenuButton<String>(
          icon: CircleAvatar(
            backgroundImage: AssetImage('tu_ruta_de_imagen'),
          ),
          onSelected: (value) {
            // Manejar la selección del desplegable
            if (value == 'verPerfil') {
              // Navegar a la pantalla "verPerfil"
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => verPerfil()),
              );
            } else if (value == 'historial') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => historial()),
              );
            } else if (value == 'configuracion') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => configuracion()),
              );
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'verPerfil',
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Ver Perfil'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'historial',
              child: ListTile(
                leading: Icon(Icons.history),
                title: Text('Historial'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'configuracion',
              child: ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configuración y Privacidad'),
              ),
            ),
          ],
        ),
        title: const Text(
          'Salas',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(

        children: [

                Expanded(
                  child: Container(

                      child: ListView(
                          shrinkWrap: true,
                          children: [
                          buildButton('+', Colors.grey, 'Crear sala', () {
                        // Navegar a la pantalla de chat cuando se presiona el botón
                        Navigator.push(context, MaterialPageRoute(builder: (context) => crearSala()));
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
                      const SizedBox(height: 20),

                          ],
                ),


              ),
            ),




          Container(
            height: 70,
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
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }

  Widget buildButton(String label, Color color, String buttonText, VoidCallback onPressed) {
    return Container(
      width: 300, // Ancho fijo
      height: 100,  // Alto fijo
      margin: const EdgeInsets.all(15),
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
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              buttonText,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
