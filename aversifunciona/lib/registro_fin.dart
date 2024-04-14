import 'dart:convert';

import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/registroValido.dart';
import 'package:flutter/material.dart';
import 'env.dart';
import 'registro4.dart';
import 'registro1.dart';
import 'package:http/http.dart' as http;

class Registro_fin extends StatefulWidget {
  @override
  _Registro_finState createState() => _Registro_finState();
}

class _Registro_finState extends State<Registro_fin> {
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _contrasena = TextEditingController();
  final TextEditingController _fecha = TextEditingController();
  final TextEditingController _pais = TextEditingController();
  bool _politicaPrivacidadAceptada = false;
  void obtenerDatosRegistro() {
    _nombre.text = registro1Key.currentState.obtenerNombreDesdeRegistro1();
    _correo.text = registro1Key.currentState.obtenerCorreoDesdeRegistro1();
    _contrasena.text = registro1Key.currentState.obtenerContrasenaDesdeRegistro1();
    _fecha.text = registro1Key.currentState.obtenerFechaDesdeRegistro1();
    _pais.text = registro1Key.currentState.obtenerPaisDesdeRegistro1();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Row(
          children: [
            // Texto de Encabezado
            Text(
              'Crear cuenta',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Campo de Género
            InputField(

              hintText: '¿Cómo te llamas?',
              controller: _nombre,
            ),

            const SizedBox(height: 10),

            const Text(
              'Esto se mostrará en tu perfil de Musify',
              style: TextStyle(color: Colors.white)
            ),
            const SizedBox(height: 10),
            SizedBox(height: 1, width: double.infinity, child: Container(color: Colors.white,)),

            const SizedBox(height: 10),
            const Text(
                'Si pulsas "Crear cuenta, aceptas los terminos y condiciones de Musify"',
                style: TextStyle(color: Colors.white, fontSize: 10)
            ),

            const SizedBox(height: 30),
            const Text(
                'Política de Privacidad',
                style: TextStyle(color: Colors.blue, fontSize: 14)
            ),
            // Opciones de género
            const SizedBox(height: 10),
            Column(
              children: [
                genderOption('Acepto la política de privacidad de Musify'),
                genderOption('Permito que Musify utilice mis datos personales para fines estadísticos y esas cosas que se dicen'),
              ],
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.bottomCenter,
              child: RoundedButton(

                text: 'Crear cuenta',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                onPressed: () {
                  String nombre = _nombre.text;
                  // Verificar si se ha aceptado la política de privacidad
                  Future<bool> registroExitoso = registroValido(nombre, correo, contrasegna, fecha, pais, _politicaPrivacidadAceptada);

                      if (registroExitoso == true) {
                      // Si el registro es exitoso, puedes navegar a la siguiente pantalla
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => pantalla_principal()),
                          );
                      }else {
                        // Si el registro no es exitoso, puedes mostrar un mensaje de error o manejarlo de otra manera
                        // Por ejemplo, mostrando un diálogo de error
                        showDialog(
                          context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                              title: Text('Error'),
                              content: Text('El registro no se pudo completar. Por favor, inténtalo de nuevo.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Cerrar el diálogo
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                          },
                        );
                      }

                },
              ),
            ),
          ],

        ),
      ),
    );
  }

  Widget genderOption(String gender) {
    return RadioListTile(
      title: Text(
        gender,
        style: const TextStyle(color: Colors.white),
      ),
      value: gender,
      groupValue: null, // No es necesario el groupValue si no se almacena internamente
      onChanged: (value) {
        setState(() {
          _politicaPrivacidadAceptada = true; // Actualizar el género seleccionado
        });
      },
      activeColor: Colors.white,
    );
  }
}

class InputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const InputField({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hintText,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.black, // Color de fondo gris
              borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
              border: Border.all(color: Colors.white), // Borde blanco
            ),
            child: TextFormField(
              style: const TextStyle(color: Colors.black),
              controller: controller,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

}