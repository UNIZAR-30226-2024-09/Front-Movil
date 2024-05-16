import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'env.dart'; // Suponiendo que aquí tienes la definición de Env.URL_PREFIX

import 'getUserSession.dart';
import 'perfilAjeno.dart';

class ListaSeguidos extends StatefulWidget {
  @override
  _ListaSeguidosState createState() => _ListaSeguidosState();
}

class _ListaSeguidosState extends State<ListaSeguidos> {
  List<Map<String, dynamic>> _listaSeguidos = [];
  String _correoS = '';

  @override
  void initState() {
    super.initState();
    _fetchSeguidos();
  }

  Future<void> _fetchSeguidos() async {
    try {
      String? token = await getUserSession.getToken();
      print("Token: $token");
      if (token != null) {
        Map<String, dynamic> userInfo = await getUserSession.getUserInfo(token);
        setState(() {
          _correoS = userInfo['correo'];
        });
        print("Correo: $_correoS");

        if (_correoS != null) {
          final response = await http.post(
            Uri.parse('${Env.URL_PREFIX}/listarSeguidos/'),
            body: jsonEncode({'correo': _correoS}),
            headers: {'Content-Type': 'application/json'},
          );
          print('Response: ${response.body}');
          if (response.statusCode == 200) {
            final Map<String, dynamic> responseData = jsonDecode(response.body);
            if (responseData.containsKey('seguidos')) {
              final List<dynamic> seguidos = responseData['seguidos'];
              print('Seguidos: $seguidos');

              setState(() {
                _listaSeguidos = seguidos.cast<Map<String, dynamic>>();
              });
            } else if (responseData.containsKey('message')) {
              setState(() {
                _listaSeguidos = []; // Marcar como cargado para evitar el indicador de carga
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No tienes seguidos'),
                ),
              );
            }
          } else {
            print('Error al obtener los usuarios seguidos: ${response.statusCode}');
          }
        } else {
          print('El correo es nulo');
        }
      } else {
        print('Token es nulo');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
    }
  }


  void _handleNavigatorResult() async {
    // Recargar la lista de seguidos
    await _fetchSeguidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            Navigator.pop(context);
            // Manejar el resultado
            _handleNavigatorResult();
          },
        ),
        title: Text('Lista de Seguidos', style: TextStyle(color: Colors.white)),
      ),
      body: _listaSeguidos.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _listaSeguidos != null
          ? ListView.builder(
        itemCount: _listaSeguidos.length,
        itemBuilder: (context, index) {
          final usuario = _listaSeguidos[index];
          return ListTile(
            title: GestureDetector(
              onTap: () async {
                print('Navegando a PerfilAjeno con datos: $usuario');
                // Navegar a la pantalla del perfil del usuario y pasar los datos del usuario
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PerfilAjeno(usuario: usuario)),
                );
                _fetchSeguidos();
              },
              child: Text(
                usuario['seguido'],
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      )
          : Center(
        child: Text('La lista de seguidos está vacía o es nula'),
      ),
    );
  }


}
