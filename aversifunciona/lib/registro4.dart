import 'package:flutter/material.dart';
import 'registro3.dart';

class Registro4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
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
            SizedBox(height: 20),

            // Campo de Género
            Text(
              '¿Cuál es tu género?',
              style: TextStyle(color: Colors.white),
            ),

            SizedBox(height: 20),

            // Opciones de género
            Column(
              children: [
                genderOption('Mujer', context),
                genderOption('Hombre', context),
                genderOption('Otro', context),
                genderOption('Prefiero no decirlo', context),
              ],
            ),

            SizedBox(height: 20),

            RoundedButton(
              text: 'Siguiente',
              backgroundColor: Colors.white,
              textColor: Colors.black,
              onPressed: () {
                // Puedes acceder al género seleccionado directamente en el onPressed
                // por ejemplo, genderOption('Mujer', context) devolverá 'Mujer'
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget genderOption(String gender, BuildContext context) {
    return RadioListTile(
      title: Text(
        gender,
        style: TextStyle(color: Colors.white),
      ),
      value: gender,
      groupValue: null, // No es necesario el groupValue si no se almacena internamente
      onChanged: (value) {
        // Puedes agregar lógica aquí si es necesario
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
          primary: backgroundColor,
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
