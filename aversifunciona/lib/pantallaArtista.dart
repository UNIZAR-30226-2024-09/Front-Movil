import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'package:aversifunciona/getUserSession.dart';

import 'historialAjeno.dart';

class PantallaArtista extends StatefulWidget {
  final Map<String, dynamic> usuario;

  PantallaArtista({required this.usuario});

  @override
  _PantallaArtistaState createState() => _PantallaArtistaState();
}

class _PantallaArtistaState extends State<PantallaArtista> {
  String _nombreS = '';
  String _correoS = '';

  @override
  void initState() {
    super.initState();
    _devolverUsuario(widget.usuario['seguido']);
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
        print(_correoS);
      } else {
        print('Token is null');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> _devolverUsuario(String correo) async {
    try {
      print('Correo: $correo');
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/devolverUsuario/'),
        body: jsonEncode({'correo': correo}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic>? usuario = responseData['usuario'];
        setState(() {
          _nombreS = usuario!['nombre'];
        });
        _getUserInfo();
      } else if (response.statusCode == 404) {
        print('Else if: El usuario no existe');
      } else {
        print('Error al obtener el usuario: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final nombre = widget.usuario['nombre'] ?? '';
    final correo = widget.usuario['correo'] ?? '';

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
        title: const Text('Artista', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('URL_DE_LA_IMAGEN_DEL_PERFIL'),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nombreS,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(height: 10),

                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            SizedBox(height: 10),


          ],
        ),
      ),
    );
  }
}

class PlaylistItem extends StatelessWidget {
  final String name;
  final String imageUrl;

  PlaylistItem({required this.name, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            color: Colors.grey,
            // Aquí puedes cargar la imagen de la playlist
          ),
          SizedBox(width: 20),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
