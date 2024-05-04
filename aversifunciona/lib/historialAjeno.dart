import 'dart:convert';

import 'package:aversifunciona/biblioteca.dart';
import 'package:aversifunciona/buscar.dart';
import 'package:aversifunciona/configuracion.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/salas.dart';
import 'package:aversifunciona/verPerfil.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'env.dart';

class historialAjeno extends StatefulWidget {
  final String correoSeguidoS; // Detalles del usuario ajeno

  historialAjeno({required this.correoSeguidoS}); // Constructor actualizado

  @override
  _historialAjenoState createState() => _historialAjenoState();
}

class _historialAjenoState extends State<historialAjeno> {
  List<dynamic> _historial = [];
  String _nombreS = '';
  String _correoSeguidoS = '';

  @override
  void initState() {
    super.initState();
    _getListarHistorial();
    //_devolverUsuario(widget.correoSeguidoS);
  }

  Future<void> _devolverUsuario(String correo) async {
    try {
      print('Correo: $correo');
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/devolverUsuario/'),
        body: jsonEncode({'correo': correo}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic>? usuario = responseData['usuario'];
        setState(() {
          _nombreS = usuario != null ? usuario['nombre'] : '';
          _correoSeguidoS = usuario != null ? usuario['correo'] : '';
        });
        print('Correo seguido: $_correoSeguidoS');
        _getListarHistorial();
      } else if (response.statusCode == 404) {
        print('Else if: El usuario no existe');
      } else {
        print('Error al obtener el usuario: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
    }
  }

  Future<void> _getListarHistorial() async {
    try {
        final response = await http.post(
          Uri.parse('${Env.URL_PREFIX}/listarHistorial/'), // Reemplaza 'tu_url_de_la_api' por la URL correcta
          body: json.encode({'correo': _correoSeguidoS}),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);

          if (responseData.containsKey('historial') && responseData['historial'] != null) {
            final List<dynamic> historialData = responseData['historial'];
            final List<String> historial = historialData.map((data) => data['nombre'].toString()).toList();

            setState(() {
              _historial = historial;
            });
          } else {
            print('No se encontraron listas de reproducción para este usuario.');
          }

          setState(() {
            _historial = responseData['historial'];
          });
        } else {
          throw Exception('Error al obtener el historial: ${response.statusCode}');
        }
    } catch (e) {
      print('Catch: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Historial de ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _historial.length,
              itemBuilder: (context, index) {
                final cancion = _historial[index];
                return ListTile(
                  title: Text(
                    cancion['nombre'] ?? '', // Reemplaza 'nombre' por el nombre del campo que contiene el nombre de la canción
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    // Acción al seleccionar una canción del historial
                  },
                );
              },
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
                    backgroundColor:Colors.transparent,
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
                    backgroundColor:Colors.transparent,
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
                    backgroundColor:Colors.transparent,
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
                    backgroundColor:Colors.transparent,
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
      margin: EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: () {
          // Navegar a la pantalla correspondiente
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => reproductor()),
          );*/
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