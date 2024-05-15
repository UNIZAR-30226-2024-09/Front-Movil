import 'dart:convert';
import 'package:aversifunciona/getUserSession.dart';
import 'package:flutter/material.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:http/http.dart' as http;
import 'biblioteca.dart';
import 'buscar.dart';
import 'chatDeSala.dart';
import 'cola.dart';
import 'env.dart';

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        pantalla_opciones(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class Sala {
  final int id;
  final String nombre;

  Sala({required this.id, required this.nombre});

  factory Sala.fromJson(Map<String, dynamic> json) {
    return Sala(
      id: json['id'],
      nombre: json['nombre'],
    );
  }

}


class pantalla_salas extends StatefulWidget {
  @override
  _PantallaSalasState createState() => _PantallaSalasState();
}

class _PantallaSalasState extends State<pantalla_salas> {
  List<Sala> _listaSalas = []; // Lista de nombres de salas
  TextEditingController salaController = TextEditingController();
  bool _isLoading = true;

  Future<void> listarSalas() async {
    try {
      var url = Uri.parse('${Env.URL_PREFIX}/listarSalas/');
      var response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
    );

    if (response.statusCode == 200) {
      // Decodificar la respuesta JSON
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> salasData = data['salas'];

      // Mapear los datos de las salas a objetos Sala
      setState(() {
        _listaSalas = salasData.map((salaData) {
          return Sala.fromJson(salaData);
        }).toList();
        _isLoading = false;
      });
      //}).toList();
    } else {
        // Manejar otros códigos de estado
        print('Error al listar las salas: ${response.statusCode}');
      }
    } catch (error) {
      // Manejar errores de red u otros errores
      print('Error listarSalas: $error');
    }
  }

  Future<void> crearNuevaSala(String nombreSala) async {
    try {
      var url = Uri.parse('${Env.URL_PREFIX}/crearSalaAPI/');
      var response = await http.post(
        url,
        body: jsonEncode({'nombre': nombreSala}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // La sala se creó exitosamente
        print('Sala creada exitosamente');
        listarSalas();
      } else {
        // Manejar otros códigos de estado
        print('Error al crear la sala: ${response.statusCode}');
      }
    } catch (error) {
      // Manejar errores de red u otros errores
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    // Obtener los datos de la playlist al inicializar el widget
    listarSalas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: TextButton(
            child: const CircleAvatar(
              child: Icon(Icons.person_rounded, color: Colors.white,),
            ),
            onPressed: () {
              Navigator.of(context).push(_createRoute());
            }
        ),
        title: const Text(
          'Salas',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [

          Expanded(
            child: _isLoading ? const Center( child: CircularProgressIndicator(),) :ListView(
              shrinkWrap: true,
              children: [
                buildButton('+', Colors.grey, 'Crear sala', () {
                  _showCreateRoomDialog(context);
                }),
                for (Sala sala in _listaSalas)
                  buildButton(sala.nombre, Colors.blue, 'Únete ahora', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatDeSala(idDeLaSala: sala.id)),
                          );
                    },
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),

        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 10), // Ajusta el valor según sea necesario para la posición deseada
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Cola()), // Suponiendo que Cola sea la pantalla a la que quieres navegar
            );
          },
          child: const Icon(Icons.queue_music),
        ),
      ),
      bottomNavigationBar: Container(
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
                    builder: (context) => pantalla_principal(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
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
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => pantalla_buscar(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
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
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => pantalla_biblioteca(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
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
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => pantalla_salas(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String label, Color color, String buttonText, VoidCallback onPressed) {
    return Container(
      width: 300, // Ancho fijo
      height: 100, // Alto fijo
      margin: const EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: onPressed, // Ahora el onPressed es dinámico
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
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

  void _showCreateRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: 300,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Nombre de la Sala',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: salaController,
                  decoration: InputDecoration(
                    hintText: 'Ingrese el nombre de la sala',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Puedes acceder al nombre de la sala usando salaController.text
                    // Agrega aquí la lógica para crear la sala con el nombre proporcionado
                    setState(() {
                      _isLoading = true;
                    });
                    String roomName = salaController.text;
                    // Agregar la nueva sala a la lista
                    crearNuevaSala(roomName);
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.pop(context); // Cerrar el diálogo
                  },
                  child: Text('Aceptar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
