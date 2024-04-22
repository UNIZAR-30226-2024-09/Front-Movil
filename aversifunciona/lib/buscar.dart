import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/salas.dart';
import 'package:flutter/material.dart';
import 'package:aversifunciona/verPerfil.dart';

import 'configuracion.dart';
import 'historial.dart';
import 'biblioteca.dart';

class HistorialItem {
  final String term;
  final DateTime timestamp;

  HistorialItem(this.term, this.timestamp);
}

class pantalla_buscar extends StatefulWidget {
  @override
  _pantalla_buscarState createState() => _pantalla_buscarState();
}

class _pantalla_buscarState extends State<pantalla_buscar> {
  List<HistorialItem> elHistorial = [];
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchSubmitted);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted() {
    String searchTerm = _searchController.text;
    if (searchTerm.isNotEmpty) {
      _agregarAlHistorial(searchTerm);
      _searchController.clear(); // Limpiar el TextField después de agregar al historial
    }
  }
  void _agregarAlHistorial(String term) {
    setState(() {
      elHistorial.add(HistorialItem(term, DateTime.now()));
    });
  }
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
          'Buscar',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: ListView(

                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: '¿Qué te apetece escuchar?',
                        hintStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Explorar todo',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildTopButton('Rap', Colors.blue.shade400),
                              buildTopButton('Clásico', Colors.red.shade400),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildTopButton('Electro', Colors.green.shade400),
                              buildTopButton('Pop', Colors.deepPurple.shade400),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildTopButton('Rock', Colors.green.shade900),
                              buildTopButton('Reggaeton', Colors.yellow.shade400),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
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

  Widget buildTopButton(String title, Color color) {
    return Container(
      width: 150,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: ElevatedButton(
        onPressed: () {
          // Acción al presionar el botón
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
