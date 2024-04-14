import 'package:aversifunciona/verPerfil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'env.dart';
class EditarPais extends StatefulWidget {
  @override
  _EditarPaisState createState() => _EditarPaisState();
}

class _EditarPaisState extends State<EditarPais> {
  TextEditingController _nuevoPaisController = TextEditingController();

  Future<bool> actualizarPais(String nuevoPais) async {
    try {
      final response = await http.put(
        Uri.parse("${Env.URL_PREFIX}/actualizarPais/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'nuevoPais': nuevoPais,
        }),
      );

      if (response.statusCode == 200) { //si es un país valido
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
                controller: _nuevoPaisController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Introduce tu país o región',
                ),
              ),
              SizedBox(height: 16.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                    String nuevoPais = _nuevoPaisController.text;
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


