import 'package:aversifunciona/registro4.dart';
import 'package:flutter/material.dart';

class Registro1 extends StatelessWidget {
  final _correo = TextEditingController();
  final _contrasegna = TextEditingController();
  final _fecha = TextEditingController();
  final _pais = TextEditingController();
  bool visible = false;
  
  String obtenerCorreoDesdeRegistro1() {
    return _correo.text;
  }

  String obtenerContrasenaDesdeRegistro1() {
    return _contrasegna.text;
  }

  String obtenerFechaDesdeRegistro1() {
    return _fecha.text;
  }

  String obtenerPaisDesdeRegistro1() {
    return _pais.text;
  }

  void mostrar(){
    debugPrint('Marianela');
    Container(
      alignment: Alignment.bottomCenter,
      child: const Text(
        '¡Completa todos los campos antes de continuar!',
        textAlign: TextAlign.center,

        style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold
        )));
  }

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
      child: SingleChildScrollView(
        child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  // Campo de Correo Electrónico
                  InputField(
                    controller: _correo,
                    hintText: 'Correo electrónico',
                  ),

                  const SizedBox(height: 10),
      ]
              ),
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const SizedBox(height: 10),

                      // Campo de Correo Electrónico
                      InputField(
                        controller: _contrasegna,
                        hintText: 'Contraseña',
                      ),

                      const SizedBox(height: 10),
                ],
              ),

              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const SizedBox(height: 10),

                    // Campo de Correo Electrónico
                    InputField(
                      controller: _fecha,
                      hintText: 'Fecha de nacimiento',
                    ),

                    const SizedBox(height: 10),
                  ]
              ),

              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const SizedBox(height: 10),

                    // Campo de Correo Electrónico
                    InputField(
                      controller: _pais,
                      hintText: 'Pais de nacimiento',
                    ),

                    const SizedBox(height: 40),
                  ]
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  RoundedButton(

                  text: 'Siguiente',
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {

                    if (_correo.text == '' || _contrasegna.text == '' || _fecha.text == '' || _pais.text == '') {
                      showDialog(context: context, builder: (BuildContext context) {
                        return const AlertDialog(
                          backgroundColor: Colors.white,
                          content: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child:  Text(
                                            '¡Completa todos los campos antes de continuar!',
                                            textAlign: TextAlign.center,

                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold
                                            )),

                                    ),);
                      });

                    }
                    else {
                      const Text(
                          '',
                          textAlign: TextAlign.center,

                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Registro4()),
                      );
                    }
                  },

                ),
                ]
              ),




        ]
      ),
      ),
    ));
  }
}


class InputField extends StatelessWidget {
  final String hintText;
  final controller;

  const InputField({
    Key? key,
    required this.hintText,
    required this.controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hintText,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.black, // Color de fondo gris
              borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
              border: Border.all(color: Colors.white), // Borde blanco
            ),
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
                controller: controller,
                decoration: const InputDecoration(


                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                hintText: '',
                filled: true,
                fillColor: Colors.transparent,
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(

                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  borderSide: BorderSide(color: Colors.white, width: 2.0),


            ),
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
