import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'env.dart'; // Suponiendo que aquí tienes la definición de Env.URL_PREFIX

import 'getUserSession.dart';

class ListaSeguidores extends StatefulWidget {
  @override
  _ListaSeguidoresState createState() => _ListaSeguidoresState();
}

class _ListaSeguidoresState extends State<ListaSeguidores> {
  List<Map<String, dynamic>> _listaSeguidores = [];
  String _correoS = '';

  @override
  void initState() {
    super.initState();
    _fetchSeguidores();
  }

  Future<void> _fetchSeguidores() async {

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
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarSeguidores/'),
        body: jsonEncode({'correo': _correoS}),
        headers: {'Content-Type': 'application/json'},
      );
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> seguidores = responseData['seguidores']; // Acceder a la lista de seguidos
        print('Seguidores: $seguidores');
        // Aquí puedes procesar la lista de seguidos según tus necesidades
        // Por ejemplo, puedes asignar la lista a una variable de estado para usarla en tu interfaz de usuario

        setState(() {
          _listaSeguidores = seguidores.cast<Map<String, dynamic>>();
        });
      } else {
        print('Error al obtener los usuarios seguidores: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
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
        title: Text('Lista de Seguidores', style: TextStyle(color: Colors.white)),
      ),
      body: _listaSeguidores.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _listaSeguidores != null
          ? ListView.builder(
        itemCount: _listaSeguidores.length,
        itemBuilder: (context, index) {
          final seguidor = _listaSeguidores[index];
          return ListTile(
            title: Text(seguidor['seguidor'], style: TextStyle(color: Colors.white)),
            // Agrega más contenido según sea necesario
          );
        },
      )
          : Center(
        child: Text('La lista de seguidores está vacía o es nula'),
      ),
    );
  }

}
