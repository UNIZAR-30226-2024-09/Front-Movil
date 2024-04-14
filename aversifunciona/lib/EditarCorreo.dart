import 'package:aversifunciona/verPerfil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'env.dart';
class EditarCorreo extends StatefulWidget {
  @override
  _EditarCorreoState createState() => _EditarCorreoState();
}

class _EditarCorreoState extends State<EditarCorreo> {
  TextEditingController _nuevoCorreoController = TextEditingController();

  Future<bool> actualizarCorreo(String nuevoCorreo) async {
    try {
      final response = await http.put(
        Uri.parse("${Env.URL_PREFIX}/actualizarCorreo/"), // Ajusta la URL según tu API
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'nuevoCorreo': nuevoCorreo,
        }),
      );

      if (response.statusCode == 200) { // si el correo existe
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
                controller: _nuevoCorreoController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Introduce tu correo electrónico',
                ),
              ),
              SizedBox(height: 16.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String nuevoPais = _nuevoCorreoController.text;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => verPerfil()), // Reemplazar 'NuevaPantalla' con el nombre de tu nueva pantalla
                      );

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


