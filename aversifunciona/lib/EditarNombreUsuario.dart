import 'package:aversifunciona/verPerfil.dart';
import 'package:flutter/material.dart';

import 'env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditarNombreUsuario extends StatefulWidget {
  @override
  _EditarNombreUsuarioState createState() => _EditarNombreUsuarioState();
}

class _EditarNombreUsuarioState extends State<EditarNombreUsuario> {
  TextEditingController _nuevoNombreUsuarioController = TextEditingController();


  Future<bool> actualizarNombreUsuario(String nuevoNombreUsuario) async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.56.1:8000/actualizarUsuario/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'nombre': nuevoNombreUsuario,
        }),
      );

      if (response.statusCode == 200) { // si no hay un usuario que se llame así
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
                controller: _nuevoNombreUsuarioController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Nuevo nombre de usuario',
                ),
              ),
              SizedBox(height: 16.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      String nuevoNombreUsuario = _nuevoNombreUsuarioController.text;

                      // Enviar la solicitud para actualizar el nombre de usuario
                      bool success = await actualizarNombreUsuario(nuevoNombreUsuario);
                      /*
                      String nuevoPais = _nuevoNombreUsuarioController.text;
                       */
                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              verPerfil()), // Reemplazar 'NuevaPantalla' con el nombre de tu nueva pantalla
                        );
                      } else {
                        print('Error al actualizar el nombre de usuario');
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


