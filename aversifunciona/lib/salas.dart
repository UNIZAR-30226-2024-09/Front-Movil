import 'package:aversifunciona/getUserSession.dart';
import 'package:flutter/material.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/verPerfil.dart';

import 'configuracion.dart';
import 'historial.dart';
import 'biblioteca.dart';
import 'buscar.dart';
import 'chatDeSala.dart';
import 'cola.dart';

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



class pantalla_salas extends StatefulWidget {
  @override
  _PantallaSalasState createState() => _PantallaSalasState();
}

class _PantallaSalasState extends State<pantalla_salas> {
  List<String> _listaSalas = ['SpainMusic', 'SiaLovers', 'EminemGroup']; // Lista de nombres de salas
  TextEditingController salaController = TextEditingController();
  //String usuarioActual = '';

  Future<String> getNombreUsuario() async {
    try {
      String? token = await getUserSession.getToken(); // Espera a que el token se resuelva
      print("Token: $token");
      if (token != null) {
        // Llama al método AuthService para obtener la información del usuario
        Map<String, dynamic> userInfo = await getUserSession.getUserInfo(token);

        String usuarioActual = userInfo['nombre'];
        return usuarioActual;

      } else {
        print('Token is null');
        return '';
      }
    } catch (e) {
      print('Error fetching user info: $e');
      return '';
    }
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
            child: ListView(
              shrinkWrap: true,
              children: [
                buildButton('+', Colors.grey, 'Crear sala', () {
                  _showCreateRoomDialog(context);
                }),
                for (String sala in _listaSalas)
                  buildButton(
                    sala,
                    Colors.blue,
                    'Únete ahora',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return FutureBuilder<String>(
                                  future: getNombreUsuario(),
                                  builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    // Maneja cualquier error que ocurra al obtener el nombre de usuario
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // Construye la pantalla de chat con el nombre de usuario obtenido
                                    return ChatDeSala(roomName: sala, userName: snapshot.data!);
                                  }
                                  },
                                );
                              },
                            ),
                          );
                    },
                  ),
                const SizedBox(height: 20),
              ],
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
          child: Icon(Icons.queue_music),
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
                    String roomName = salaController.text;
                    // Agregar la nueva sala a la lista
                    setState(() {
                      _listaSalas.add(roomName);
                    });
                    // Lógica para crear la sala
                    Navigator.pop(context); // Cerrar el diálogo
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return FutureBuilder<String>(
                            future: getNombreUsuario(),
                            builder: (context, snapshot) {

                            if (snapshot.hasError) {
                              // Maneja cualquier error que ocurra al obtener el nombre de usuario
                              return Text('Error: ${snapshot.error}');
                            } else {
                              // Construye la pantalla de chat con el nombre de usuario obtenido
                              return ChatDeSala(roomName: roomName, userName: snapshot.data!);
                            }

                            },
                          );
                        },
                      ),
                    );
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
