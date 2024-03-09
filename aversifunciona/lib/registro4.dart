import 'package:flutter/material.dart';
import 'registro_fin.dart';

class Registro4 extends StatelessWidget {
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

      body: Center(
          child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const SizedBox(height: 20),

                    // Campo de Género

                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(

                      '¿Cuál es tu género?',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),

                    const SizedBox(height: 20),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        genderOption('Mujer', context),
                        genderOption('Hombre', context),
                        genderOption('Otro', context),
                        genderOption('Prefiero no decirlo', context),
                      ],
                    ),

                    const SizedBox(height: 20),
                ]
          ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundedButton(

                        text: 'Siguiente',
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Registro_fin()),
                          );
                        },
                      ),
                    ]
                )
        ]
      ),
    ),
    );
  }



  Widget genderOption(String gender, BuildContext context) {
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
