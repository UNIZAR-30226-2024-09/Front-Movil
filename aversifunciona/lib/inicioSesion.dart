import 'package:aversifunciona/pantalla_principal.dart';
import 'package:flutter/material.dart';

class InicioSesion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,  // Ajuste del fondo a negro

      body: Center(
        child: Container(
          width: 400,
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
                SizedBox(height: 20),

                // Campo de Correo Electrónico o Nombre de Usuario
                InputField(
                  hintText: 'Correo electrónico o nombre de usuario',
                ),

                SizedBox(height: 10),

                // Campo de Contraseña
                InputField(
                  hintText: 'Contraseña',
                  isPassword: true,
                ),

                SizedBox(height: 20),

                // Botón de Iniciar Sesión
                RoundedButton(
                  text: 'Iniciar Sesión',
                  backgroundColor: Colors.blue.shade400,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => pantalla_principal()),
                    );
                  },
                ),
              ],
            ),
            ),

          ],
        ),
        ),


    ),
    );
  }
}

class InputField extends StatelessWidget {
  final String hintText;
  final bool isPassword;

  const InputField({
    Key? key,
    required this.hintText,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hintText,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 8),
          TextFormField(
            obscureText: isPassword,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              filled: true,
              fillColor: Colors.grey[850],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
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

          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
