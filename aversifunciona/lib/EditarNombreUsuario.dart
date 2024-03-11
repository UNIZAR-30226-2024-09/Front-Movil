import 'package:aversifunciona/verPerfil.dart';
import 'package:flutter/material.dart';

class EditarNombreUsuario extends StatefulWidget {
  @override
  _EditarNombreUsuarioState createState() => _EditarNombreUsuarioState();
}

class _EditarNombreUsuarioState extends State<EditarNombreUsuario> {
  TextEditingController _nuevoNombreUsuarioController = TextEditingController();

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
                controller: _nuevoNombreUsuarioController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Nuevo nombre de usuario',
                ),
              ),
              SizedBox(height: 16.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String nuevoPais = _nuevoNombreUsuarioController.text;
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


