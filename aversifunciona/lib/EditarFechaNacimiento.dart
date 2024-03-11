import 'package:aversifunciona/verPerfil.dart';
import 'package:flutter/material.dart';

class EditarFechaNacimiento extends StatefulWidget {
  @override
  _EditarFechaNacimientoState createState() => _EditarFechaNacimientoState();
}

class _EditarFechaNacimientoState extends State<EditarFechaNacimiento> {
  TextEditingController _nuevoFechaNacimientoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nuevoFechaNacimientoController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Introduce tu fecha de nacimiento',
                ),
              ),
              SizedBox(height: 16.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String sexo = _nuevoFechaNacimientoController.text;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => verPerfil()), // Reemplazar 'NuevaPantalla' con el nombre de tu nueva pantalla
                      );

                    },
                    child: Text('Aceptar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para cancelar la edición de la contraseña
                      Navigator.pop(context); // Vuelve a la pantalla anterior
                    },
                    child: Text('Cancelar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


