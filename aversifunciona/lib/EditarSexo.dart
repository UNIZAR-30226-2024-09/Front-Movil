import 'package:aversifunciona/verPerfil.dart';
import 'package:flutter/material.dart';

class EditarSexo extends StatefulWidget {
  @override
  _EditarSexoState createState() => _EditarSexoState();
}

class _EditarSexoState extends State<EditarSexo> {
  TextEditingController _nuevoSexoController = TextEditingController();

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
                controller: _nuevoSexoController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Introduce tu sexo',
                ),
              ),
              SizedBox(height: 16.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String sexo = _nuevoSexoController.text;
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


