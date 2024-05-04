import 'dart:convert';
import 'package:aversifunciona/biblioteca.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aversifunciona/getUserSession.dart';

import 'env.dart';

class CrearPlaylist extends StatefulWidget {
  @override
  _CrearPlaylistState createState() => _CrearPlaylistState();
}

class _CrearPlaylistState extends State<CrearPlaylist> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _playlistNameController = TextEditingController();
  bool _isPublic = true; // Inicialmente se establece como pública
  String _correoS = '';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    try {
      String? token = await getUserSession.getToken(); // Espera a que el token se resuelva
      print("Token: $token");
      if (token != null) {
        // Llama al método AuthService para obtener la información del usuario
        Map<String, dynamic> userInfo = await getUserSession.getUserInfo(token);
        setState(() {
          _correoS = userInfo['correo'];
        });
      } else {
        print('Token is null');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> _crearPlaylist() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('${Env.URL_PREFIX}/crearPlaylist/'), // Reemplaza 'URL_DE_TU_API' con la URL de tu API
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'correo': _correoS,
            'nombre': _playlistNameController.text,
            'publica': _isPublic,
          }),
        );
        if (response.statusCode == 200) {
          // La playlist se creó con éxito
          // Puedes agregar aquí la navegación a otra pantalla si lo deseas
          print('La playlist se creó con éxito');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => pantalla_biblioteca()), // Suponiendo que el nombre de la pantalla sea CrearPlaylist
          );
        } else {
          // Ocurrió un error al crear la playlist
          print('Error al crear la playlist: ${response.statusCode}');
        }
      } catch (e) {
        print('Error al enviar la solicitud: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Crear Playlist', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _playlistNameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la playlist',
                  labelStyle: TextStyle(color: Colors.white), // Cambiar color del texto del label
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Colors.white), // Cambiar color del texto dentro del campo
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre para la playlist';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Pública:', style: TextStyle(color: Colors.white)),
                  Switch(
                    value: _isPublic,
                    onChanged: (value) {
                      setState(() {
                        _isPublic = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    _crearPlaylist();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Crear',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
