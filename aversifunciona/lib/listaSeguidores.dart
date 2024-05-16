import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'perfilAjenoSeguidor.dart';
import 'getUserSession.dart';

class ListaSeguidores extends StatefulWidget {
  @override
  _ListaSeguidoresState createState() => _ListaSeguidoresState();
}

class _ListaSeguidoresState extends State<ListaSeguidores> {
  List<Map<String, dynamic>> _listaSeguidores = [];
  String? _correoS;

  @override
  void initState() {
    super.initState();
    _fetchSeguidores();
  }

  Future<void> _fetchSeguidores() async {
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
            Uri.parse('${Env.URL_PREFIX}/listarSeguidores/'),
            body: jsonEncode({'correo': _correoS}),
            headers: {'Content-Type': 'application/json'},
          );
          print('Response: ${response.body}');
          if (response.statusCode == 200) {
            final Map<String, dynamic> responseData = jsonDecode(response.body);
            if (responseData.containsKey('seguidores')) {
              final List<dynamic> seguidores = responseData['seguidores'];
              print('Seguidores: $seguidores');

              setState(() {
                _listaSeguidores = seguidores.cast<Map<String, dynamic>>();
              });
            } else if (responseData.containsKey('message')) {
              setState(() {
                _listaSeguidores = []; // Marcar como cargado para evitar el indicador de carga
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No tienes seguidores'),
                ),
              );
            }
          } else {
            print('Error al obtener los usuarios seguidores: ${response.statusCode}');
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
    await _fetchSeguidores();
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
            _handleNavigatorResult();
          },
        ),
        title: Text('Lista de Seguidores', style: TextStyle(color: Colors.white)),
      ),
      body: _listaSeguidores.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: _listaSeguidores.length,
        itemBuilder: (context, index) {
          final seguidor = _listaSeguidores[index];
          final String nombreSeguidor = seguidor['seguidor'] ?? 'Sin nombre'; // Maneja el caso de valor nulo
          return ListTile(
            title: GestureDetector(
              onTap: () async {
                print('Navegando a PerfilAjeno con datos: $seguidor');
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PerfilAjenoSeguidor(usuario: seguidor),
                  ),
                );
                _fetchSeguidores();
              },
              child: Text(
                nombreSeguidor,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
