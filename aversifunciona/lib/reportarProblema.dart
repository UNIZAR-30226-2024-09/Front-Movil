import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aversifunciona/getUserSession.dart';
import 'package:flutter/material.dart';

import 'env.dart';

class reportarProblema extends StatefulWidget {
  @override
  _reportarProblema createState() => _reportarProblema();
}

class _reportarProblema extends State<reportarProblema> {
  String _tipoProblema = '';
  String _descripcion = '';
  String correo = '';

  final TextEditingController _problemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }


  Future<void> _getUserInfo() async {
    try {
      debugPrint('Solicitamos el token');
      String? token = await getUserSession.getToken(); // Espera a que el token se resuelva
      debugPrint("Token: $token");
      if (token != null) {
        // Llama al método AuthService para obtener la información del usuario
        Map<String, dynamic> userInfo = await getUserSession.getUserInfo(token);
        setState(() {
          correo = userInfo['correo'];
        });
        debugPrint(correo);
      } else {
        debugPrint('Token is null');
      }
    } catch (e) {
      debugPrint('Error fetching user info: $e');
    }
  }


  Future<void> _enviarReporte() async {
    debugPrint("Llamada a _enviarReporte");
    if (correo == null) {
      debugPrint("El usuario no está identificado ");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Usuario no identificado'),
          content: const Text('Asegúrate de haber iniciado sesión.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      return;
    }
    debugPrint("El usuario está identificado ");
    final url = '${Env.URL_PREFIX}/reporteAPI/';
    final body = jsonEncode({
      'correo': "musify2024@gmail.com",
      'mensaje': 'Tipo de problema: $_tipoProblema, Descripción: $_descripcion',
    });
    debugPrint('Tipo de problema: $_tipoProblema');
    debugPrint('Descripción del problema: $_descripcion');

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
      debugPrint('Mensaje del servidor');
      if (response.statusCode == 200) {
        // El servidor respondió con un código de estado 200 (OK)
        // Mostrar un cuadro de diálogo confirmando al usuario que el reporte se envió correctamente
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¡Reporte enviado!'),
            content: const Text('Hemos recibido tu reporte. Nos pondremos en contacto contigo para resolver el problema.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cerrar'),
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
            title: const Text('Error'),
            content: const Text('Error al enviar el reporte.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      debugPrint('Mensaje del servidor recibido');
    } catch (error) {
      debugPrint('Error al enviar el reporte: $error');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Error al enviar el reporte.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
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
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 10),
            const Icon(Icons.account_circle, color: Colors.white, size: 30), // Icono redondeado de la foto de perfil
            const SizedBox(width: 10),
            const Text('Reportar problema', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.black, // Cambio de color de fondo a negro
        automaticallyImplyLeading: false, // Eliminar el botón de retroceso predeterminado
      ),
    body: SingleChildScrollView(
      child: Container( // Cambio a Container para establecer el color de fondo
        color: Colors.black, // Color de fondo negro
        padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
              'Tipo de problema:', // Nuevo texto
              style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 10), // Espacio entre el nuevo texto y el campo de texto
              Row(
                  children: [
                    Text(
                      _tipoProblema.isNotEmpty ? _tipoProblema : 'Seleccione un problema', // Mostrar el tipo de problema seleccionado o un texto predeterminado si no se ha seleccionado ninguno
                      style: TextStyle(fontSize: 16, color: _tipoProblema.isNotEmpty ? Colors.white : Colors.grey[400]), // Cambiar el color del texto si se ha seleccionado un problema
                    ),
                    DropdownButton( // Desplegable para seleccionar el tipo de problema
                      // Aquí puedes definir la lista de opciones y la lógica de selección
                      // Por ahora, solo incluiré un ejemplo básico
                      items: const [
                        DropdownMenuItem(
                          value: 'Técnico',
                          child: Text('Errores técnicos'),
                        ),
                        DropdownMenuItem(
                          value: 'Servicio',
                          child: Text('Violación de términos de servicio'),
                        ),
                        DropdownMenuItem(
                          value: 'Seguridad',
                          child: Text('Problemas de seguridad'),
                        ),
                        DropdownMenuItem(
                          value: 'Contenido',
                          child: Text('Errores de contenido'),
                        ),
                        DropdownMenuItem(
                          value: 'Otros',
                          child: Text('Otros'),
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
              const SizedBox(height: 20), // Espacio entre el desplegable y el campo de texto de descripción
              const Text(
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
                  border: const OutlineInputBorder(),
                  hintStyle: TextStyle(color: Colors.grey[400]), // Gris más claro
                ),
              ),
              const SizedBox(height: 20),
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
                child: const Text('Enviar', style: TextStyle(color: Colors.white)),
              ),
  
            ],
        ),
      ),
    ),
    );
  }
}
