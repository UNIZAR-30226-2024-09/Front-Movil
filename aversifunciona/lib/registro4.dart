import 'package:flutter/material.dart';
import 'registro_fin.dart';

class Registro4 extends StatefulWidget {
  @override
  _Registro4State createState() => _Registro4State();
}
class _Registro4State extends State<Registro4> {
  String _genero = '';
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
                        genderOption('Mujer'),
                        genderOption('Hombre'),
                        genderOption('Otro'),
                        genderOption('Prefiero no decirlo'),
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
      groupValue: _genero, // Establecer el valor del grupo al género seleccionado
      onChanged: (value) {
        setState(() {
          _genero = value.toString(); // Actualizar el género seleccionado
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
