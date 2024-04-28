import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:aversifunciona/getUserSession.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final token = getUserSession.getToken();
    final url = 'http://127.0.0.1:8000/obtenerUsuarioSesionAPI/';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'token': token}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _user = data;
        });
      } else {
        print('Failed to fetch user details: $data');
      }
    } catch (error) {
      print('Error fetching user details: $error');
    }
  }


  Future<void> _enviarReporte() async {
    if (_user['correo'] == null) {
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

    final url = 'http://localhost:8000/reporteAPI/';
    final body = jsonEncode({
      'correo': _user['correo'],
      'mensaje': 'Tipo de problema: $_tipoProblema, Descripción: $_descripcion',
    });

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
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Mensaje del servidor'),
          content: Text(data['message']), 
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
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
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, // Eliminar el botón de retroceso predeterminado
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tipo de problema', // Nuevo texto
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 10), // Espacio entre el nuevo texto y el campo de texto
            DropdownButton( // Desplegable para seleccionar el tipo de problema
              // Aquí puedes definir la lista de opciones y la lógica de selección
              // Por ahora, solo incluiré un ejemplo básico
              items: [
                DropdownMenuItem(
                  child: Text('Errores técnicos'),
                  value: 'tecnicos',
                ),
                DropdownMenuItem(
                  child: Text('Violación de términos de servicio'),
                  value: 'servicio',
                ),
                DropdownMenuItem(
                  child: Text('Problemas de seguridad'),
                  value: 'seguridad',
                ),
                DropdownMenuItem(
                  child: Text('Errores de contenido'),
                  value: 'contenido',
                ),
                DropdownMenuItem(
                  child: Text('Otros'),
                  value: 'otros',
                ),

              ],
              onChanged: (value) {
                setState(() {
                  _tipoProblema = value ?? '';
                });

              },
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

                // Mostrar el diálogo de confirmación
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
              },
              child: Text('Enviar', style: TextStyle(color: Colors.white)),
            ),

          ],
        ),
      ),
    );
  }
}
