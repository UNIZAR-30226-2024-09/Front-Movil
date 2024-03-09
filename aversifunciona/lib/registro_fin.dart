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
            const InputField(

              hintText: '¿Cómo te llamas?',
            ),

            const SizedBox(height: 10),

            const Text(
              'Esto se mostrará en tu perfil de Musify',
              style: TextStyle(color: Colors.white)
            ),
            const SizedBox(height: 5),
            const Text(
                '______________________________________________________',
                style: TextStyle(color: Colors.white)
            ),
            const SizedBox(height: 10),
            const Text(
                'Si pulsas "Crear cuenta, aceptas los terminos y condiciones de Musify"',
                style: TextStyle(color: Colors.white, fontSize: 10)
            ),

            const SizedBox(height: 20),
            const Text(
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

            const SizedBox(height: 20),

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
        style: const TextStyle(color: Colors.white),
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