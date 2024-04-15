import 'package:flutter/material.dart';
import 'registro3.dart';

// PANTALLA LEGADA, ELIMINAR CUANDO SEA POSIBLE

class Registro2 extends StatelessWidget {
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
      body: Center(
          child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    SizedBox(height: 20),

                    // Campo de Correo Electrónico
                    InputField(

                      hintText: 'Contraseña',
                    ),

                    SizedBox(height: 20),



                  ],
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoundedButton(

                        text: 'Siguiente',
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Registro3()),
                          );
                        },
                      ),
                    ]
                )
              ]
          )

      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String hintText;

  const InputField({
    Key? key,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hintText,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.black, // Color de fondo gris
              borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
              border: Border.all(color: Colors.white), // Borde blanco
            ),
            child: TextFormField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
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

