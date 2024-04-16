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
  _Registro_finState createState() => _Registro_finState(correo: correo, contrasegna: contrasegna, fecha: fecha, pais: pais, genero: genero);

  const Registro_fin({required this.correo, required this.contrasegna, required this.fecha, required this.pais, required this.genero});

  final String correo;
  final String contrasegna;
  final String fecha;
  final String pais;
  final String genero;
}

class _Registro_finState extends State<Registro_fin> {

  _Registro_finState({required this.correo, required this.contrasegna, required this.fecha, required this.pais, required this.genero});

  final String correo;
  final String contrasegna;
  final String fecha;
  final String pais;
  final String genero;

  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _contrasena = TextEditingController();
  final TextEditingController _fecha = TextEditingController();
  final TextEditingController _pais = TextEditingController();
  bool _politicaPrivacidadAceptada = false;

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
      body: SingleChildScrollView(
        child: Padding(
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
                  if (_nombre.text == ''){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Introduzca un nombre de usuario'),
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
                  else if (!_politicaPrivacidadAceptada){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Debes aceptar la política de privacidad para poder continuar'),
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
                  else{
                    String nombre = _nombre.text;
                    // Verificar si se ha aceptado la política de privacidad
                    Future<bool> registroExitoso = registroValido(nombre, correo, contrasegna, fecha, pais, genero, _politicaPrivacidadAceptada);

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
                  }

                },
              ),
            ),
          ],

        ),
      ),
      )
    );
  }

  Widget genderOption(String gender) {
    return RadioListTile(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(
        horizontal: VisualDensity.minimumDensity,
        vertical: VisualDensity.minimumDensity,
      ),
      title: Text(
        gender,
        style: TextStyle(color: Colors.white),
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

class RoundedButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const RoundedButton({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,

      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
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
              style: const TextStyle(color: Colors.white),
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