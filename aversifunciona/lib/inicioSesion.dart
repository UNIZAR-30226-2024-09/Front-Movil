import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'env.dart';

import 'package:aversifunciona/pantalla_principal.dart';
import 'userPassword.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InicioSesion extends StatelessWidget {
  var _contrasegna = TextEditingController();
  var _correo = TextEditingController();


  Future<bool> loginValido(String correo, String contrasegna) async {
    try{
      final response = await http.post(
        Uri.parse("${Env.URL_PREFIX}/iniciarSesion/"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },

        body: jsonEncode(<String, String>{
            'correo': correo,
            'contrasegna': contrasegna,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("Paula");
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
      backgroundColor: Colors.black,  // Ajuste del fondo a negro

      body: Center(

        child: SingleChildScrollView(
        child: Container(
          width: 400,
          height: 640,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                Colors.cyan.shade800,
              ],
          )
        ),


            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,

            children: [
            // Logo


              Container(
              alignment: Alignment.center,
              width: 270,
              height: 530,

              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.55),
                borderRadius: BorderRadius.circular(0.5),
              ),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                // Logo
                Container(),
                Image.asset(
                  'lib/logoMusify.png', // Reemplazar 'assets/logo.png' con la ruta del logo
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 20),


                const Text("Correo electrónico", style: TextStyle(color: Colors.white), textAlign: TextAlign.left,),
                const SizedBox(height: 10),

                // Campo de Correo Electrónico o Nombre de Usuario
                Container(
                  width: 250,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _correo,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(

                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      hintText: 'Correo electrónico',
                      filled: true,
                      fillColor: Colors.transparent,
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(

                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                const Text("Contraseña", style: TextStyle(color: Colors.white), textAlign: TextAlign.left,),
                const SizedBox(height: 10),
                // Campo de Contraseña
                /*
                const InputField(
                  hintText: 'Contraseña',
                  hintTextInside: 'Contraseña',
                  isPassword: true,
                ),
                */

                // Tendremos que modificar todos los InputField por TextField y cambiar más cosillas
                Container(
                  width: 250,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _contrasegna,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(

                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      hintText: 'Contraseña',
                      filled: true,
                      fillColor: Colors.transparent,
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(

                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                      ),
                    ),
                    obscureText: true,
                  ),
                ),


                const SizedBox(height: 20),

                // Botón de Iniciar Sesión
                RoundedButton(
                  text: 'Iniciar Sesión',
                  backgroundColor: Colors.blue.shade400,
                  textColor: Colors.white,
                  onPressed: () async{
                    if (await loginValido(_correo.text, _contrasegna.text)){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => pantalla_principal())
                      );
                    }
                    else{
                      showDialog(context: context, builder: (BuildContext context) {
                        return const AlertDialog(
                          backgroundColor: Colors.white,
                          content: Padding(
                            padding: EdgeInsets.all(8.0),
                            child:  Text(
                                'Correo y/o contraseña incorrecto(s)',
                                textAlign: TextAlign.center,

                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold
                                )),

                          ),);
                      });
                    }

                  },
                ),
              ],
            ),
            ),
            ],
            ),

        ),
        ),


    ),
    );
  }
}

class InputField extends StatelessWidget {
  final String hintText;
  final String hintTextInside;
  final bool isPassword;

  const InputField({
    Key? key,
    required this.hintText,
    required this.hintTextInside,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hintText,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          TextFormField(
            obscureText: isPassword,
            style: const TextStyle(color: Colors.white),

            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              hintText: hintTextInside,
              filled: true,
              fillColor: Colors.transparent,
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(

                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
              ),
            ),
          ),
        ],
      ),
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
      width: 220,

      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade400,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          text,

          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
