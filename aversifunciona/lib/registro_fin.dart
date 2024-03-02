import 'package:aversifunciona/pantalla_principal.dart';
import 'package:flutter/material.dart';
import 'registro3.dart';

class Registro_fin extends StatelessWidget {
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
            SizedBox(height: 10),

            // Campo de Género
            InputField(
              hintText: '¿Cómo te llamas?',
            ),

            Text(
              'Esto se mostrará en tu perfil de Musify',
              style: TextStyle(color: Colors.white)
            ),
            SizedBox(height: 5),
            Text(
                '______________________________________________________',
                style: TextStyle(color: Colors.white)
            ),
            SizedBox(height: 10),
            Text(
                'Si pulsas "Crear cuenta, aceptas los terminos y condiciones de Musify"',
                style: TextStyle(color: Colors.white, fontSize: 10)
            ),

            SizedBox(height: 20),
            Text(
                'Política de Privacidad',
                style: TextStyle(color: Colors.blue)
            ),
            // Opciones de género
            Column(
              children: [
                genderOption('Acepto Marianela', context),
                genderOption('Permito que Musify utilice mi Marianela', context),
              ],
            ),

            SizedBox(height: 20),

            Align(
              alignment: Alignment.center,
              child: RoundedButton(

                text: 'Crear cuenta',
                backgroundColor: Colors.white,
                textColor: Colors.black,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => pantalla_principal()),
                  );
                },
              ),
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