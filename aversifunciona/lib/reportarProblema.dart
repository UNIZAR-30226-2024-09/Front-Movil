import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aversifunciona/getUserSession.dart';
import 'package:flutter/material.dart';

class reportarProblema extends StatefulWidget {
  @override
  _reportarProblema createState() => _reportarProblema();
}

class _reportarProblema extends State<reportarProblema> {
  String _tipoProblema = '';
  String _descripcion = '';
  Map<String, dynamic> _user = {};

  final TextEditingController _problemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }


  Future<void> _fetchUserDetails() async {
    print('Solicitamos el token');
    final token = getUserSession.getToken();
    _user = getUserSession.getUserInfo(token as String) as Map<String, dynamic>;
  }


  Future<void> _enviarReporte() async {
    print("Llamada a _enviarReporte");
    if (_user['correo'] == null) {
      print("El usuario no está identificado ");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Usuario no identificado'),
          content: Text('Asegúrate de haber iniciado sesión.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );

      return;
    }
    print("El usuario está identificado ");
    final url = 'http://localhost:8000/reporteAPI/';
    final body = jsonEncode({
      'correo': _user['correo'],
      'mensaje': 'Tipo de problema: $_tipoProblema, Descripción: $_descripcion',
    });
    print('Tipo de problema: $_tipoProblema');
    print('Descripción del problema: $_descripcion');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: body,
      );
      final data = jsonDecode(response.body);
      print('Mensaje del servidor');
      if (response.statusCode == 200) {
        // El servidor respondió con un código de estado 200 (OK)
        // Mostrar un cuadro de diálogo confirmando al usuario que el reporte se envió correctamente
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('¡Reporte enviado!'),
            content: Text('Hemos recibido tu reporte. Nos pondremos en contacto contigo para resolver el problema.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cerrar'),
              ),
            ],
          ),
        );
      } else {
        // El servidor respondió con un código de estado diferente de 200
        // Mostrar un cuadro de diálogo indicando que ocurrió un error al enviar el reporte
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Error al enviar el reporte.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
      print('Mensaje del servidor recibido');
    } catch (error) {
      print('Error al enviar el reporte: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Error al enviar el reporte.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 10),
            Icon(Icons.account_circle, color: Colors.white, size: 30), // Icono redondeado de la foto de perfil
            SizedBox(width: 10),
            Text('Reportar problema', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.black, // Cambio de color de fondo a negro
        automaticallyImplyLeading: false, // Eliminar el botón de retroceso predeterminado
      ),
      body: Container( // Cambio a Container para establecer el color de fondo
        color: Colors.black, // Color de fondo negro
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tipo de problema', // Nuevo texto
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 10), // Espacio entre el nuevo texto y el campo de texto
            Row(
                children: [
                  Text(
                    _tipoProblema.isNotEmpty ? _tipoProblema : 'Seleccione un problema', // Mostrar el tipo de problema seleccionado o un texto predeterminado si no se ha seleccionado ninguno
                    style: TextStyle(fontSize: 16, color: _tipoProblema.isNotEmpty ? Colors.white : Colors.grey[400]), // Cambiar el color del texto si se ha seleccionado un problema
                  ),
                  DropdownButton( // Desplegable para seleccionar el tipo de problema
                    // Aquí puedes definir la lista de opciones y la lógica de selección
                    // Por ahora, solo incluiré un ejemplo básico
                    items: [
                      DropdownMenuItem(
                        child: Text('Errores técnicos'),
                        value: 'Técnico',
                      ),
                      DropdownMenuItem(
                        child: Text('Violación de términos de servicio'),
                        value: 'Servicio',
                      ),
                      DropdownMenuItem(
                        child: Text('Problemas de seguridad'),
                        value: 'Seguridad',
                      ),
                      DropdownMenuItem(
                        child: Text('Errores de contenido'),
                        value: 'Contenido',
                      ),
                      DropdownMenuItem(
                        child: Text('Otros'),
                        value: 'Otros',
                      ),

                    ],
                    onChanged: (value) {
                      setState(() {
                        _tipoProblema = value ?? '';
                      });

                    },
                  ),
                ]
            ),
            SizedBox(height: 20), // Espacio entre el desplegable y el campo de texto de descripción
            Text(
              'Descripción del problema',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _problemController,
              maxLines: 5,
              style: TextStyle(color: Colors.grey[400]),
              decoration: InputDecoration(
                hintText: 'Describe el problema aquí...',
                border: OutlineInputBorder(),
                hintStyle: TextStyle(color: Colors.grey[400]), // Gris más claro
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String problemDescription = _problemController.text;

                setState(() {
                  _descripcion = problemDescription;
                });
                _enviarReporte();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Color de fondo del botón
              ),
              child: Text('Enviar', style: TextStyle(color: Colors.white)),
            ),

          ],
        ),
      ),
    );
  }
}
