import 'package:aversifunciona/verPerfil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'env.dart';

class EditarContrasena extends StatefulWidget {
  @override
  _EditarContrasenaState createState() => _EditarContrasenaState();
}

class _EditarContrasenaState extends State<EditarContrasena> {
  TextEditingController _nuevaContrasenaController = TextEditingController();
  TextEditingController _repetirContrasenaController = TextEditingController();

  Future<bool> actualizarContrasena(String nuevaContrasena) async {
    try {
      final response = await http.put(
        Uri.parse("${Env.URL_PREFIX}/actualizarContrasena/"), // Ajusta la URL según tu API
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'nuevaContrasena': nuevaContrasena,
        }),
      );

      if (response.statusCode == 200) {
        // Si la solicitud es exitosa, retornar verdadero
        return true;
      } else {
        // Si la solicitud no es exitosa, retornar falso
        return false;
      }
    } catch (e) {
      // Si ocurre algún error, retornar falso
      print("Error al realizar la solicitud HTTP: $e");
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nuevaContrasenaController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Nueva Contraseña',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _repetirContrasenaController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Repetir Contraseña',
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para aceptar la nueva contraseña
                      String nuevaContrasena = _nuevaContrasenaController.text;
                      String repetirContrasena = _repetirContrasenaController.text;

                      // Validar si las contraseñas coinciden
                      if (nuevaContrasena == repetirContrasena) {
                        // Realizar acciones necesarias con la nueva contraseña
                        // (puede incluir la navegación a otra pantalla)
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => verPerfil()), // Reemplazar 'NuevaPantalla' con el nombre de tu nueva pantalla
                        );
                      } else {
                        // Manejar caso en el que las contraseñas no coincidan
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Las contraseñas no coinciden.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('Aceptar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para cancelar la edición de la contraseña
                      Navigator.pop(context); // Vuelve a la pantalla anterior
                    },
                    child: Text('Cancelar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


