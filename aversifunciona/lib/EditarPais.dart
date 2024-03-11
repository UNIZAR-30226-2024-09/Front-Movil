import 'package:aversifunciona/verPerfil.dart';
import 'package:flutter/material.dart';

class EditarPais extends StatefulWidget {
  @override
  _EditarPaisState createState() => _EditarPaisState();
}

class _EditarPaisState extends State<EditarPais> {
  TextEditingController _nuevoPaisController = TextEditingController();

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
                controller: _nuevoPaisController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Introduce tu país o región',
                ),
              ),
              SizedBox(height: 16.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                    String nuevoPais = _nuevoPaisController.text;
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


