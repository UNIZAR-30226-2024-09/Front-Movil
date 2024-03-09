import 'package:flutter/material.dart';
import 'registro1.dart';
import 'google.dart';
import 'inicioSesion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Center(
        child: Container(
          width: 400, // Cuando lo encontremos, cambiar por algo que permita
          // que se ajuste al tamaño de la pantalla en cuestión
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black87,
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
              color: Colors.black.withOpacity(0.55),

              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,


              children: [
                // Logo
                Image.asset(
                  'lib/logoMusify.png', // Reemplazar 'assets/logo.png' con la ruta del logo
                  width: 150,
                  height: 150,
                ),
                SizedBox(height: 20),

                // Botones
                RoundedButton(
                  text: 'Iniciar Sesión',
                  backgroundColor: Colors.blue,
                  textColor: Colors.black,

                  onPressed: () {
                    // Navegar a la pantalla de registro
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InicioSesion()),
                    );
                  },
                ),
                GoogleButton(
                  text: 'Continuar con Google',
                  backgroundColor: Colors.black,
                  textColor: Colors.red,
                  onPressed: () {
                    // Navegar a la pantalla de Google
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Google()),
                    );
                  },
                ),
                TransparentButton(
                  text: 'Registrarse',
                  textColor: Colors.white,
                  onPressed: () {
                    // Navegar a la pantalla de inicio de sesión
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Registro1()),
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

      margin: EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: Colors.white),
          backgroundColor: Colors.transparent,
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

class GoogleButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const GoogleButton({
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
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          side: const BorderSide(color: Colors.white),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Image.asset('lib/googleLogo.png', width: 20, height: 20,),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ),
        ),

    );
  }
}


// Icon(Icons.account_circle, size: 40),

class TransparentButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final VoidCallback onPressed;

  const TransparentButton({
    Key? key,
    required this.text,
    required this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        side: BorderSide(color: Colors.transparent),
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
