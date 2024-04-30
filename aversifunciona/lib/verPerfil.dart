import 'dart:convert';

import 'package:aversifunciona/editarPerfil.dart';
import 'package:aversifunciona/getUserSession.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'env.dart';

class verPerfil extends StatefulWidget {
  @override
  _verPerfilState createState() => _verPerfilState();
}

class _verPerfilState extends State<verPerfil> {

  String _nombreS = '';
  String _correoS = '';
  List<String> _playlists = [];
  String _numSeguidos = '0';
  String _numSeguidores = '0';


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
          _nombreS = userInfo['nombre'];
          _correoS = userInfo['correo'];
        });
        print(_correoS);
        _fetchSeguidosSeguidores();
        _getUserPlaylists();
      } else {
        print('Token is null');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> _fetchSeguidosSeguidores() async {
    try {
      // Hacer una solicitud HTTP para obtener los números de seguidos y seguidores
      final responseSeguidos = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarSeguidos/'),
        body: jsonEncode({'correo': _correoS}),
        headers: {'Content-Type': 'application/json'},
      );

      final responseSeguidores = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarSeguidores/'),
        body: jsonEncode({'correo': _correoS}),
        headers: {'Content-Type': 'application/json'},
      );

      // Procesar la respuesta y extraer los números
      if (responseSeguidos.statusCode == 200 && responseSeguidores.statusCode == 200) {
        final Map<String, dynamic> dataSeguidos = jsonDecode(responseSeguidos.body);
        final Map<String, dynamic> dataSeguidores = jsonDecode(responseSeguidores.body);
        setState(() {
          //_numSeguidos = dataSeguidos['numSeguidos'].toString() ?? '0';
          //_numSeguidores = dataSeguidores['numSeguidores'].toString() ?? '0';
          _numSeguidos = dataSeguidos['numSeguidos'] != null ? dataSeguidos['numSeguidos'].toString() : '0';
          _numSeguidores = dataSeguidores['numSeguidores'] != null ? (dataSeguidores['numSeguidores']).toString() : '0';
        });
      } else {
        throw Exception('Error al obtener los números de seguidos y seguidores');
      }
    } catch (e) {
      print('Catch: $e');
    }
  }

  Future<void> _fetchSeguidos() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarSeguidos/'),
        body: jsonEncode({'correo': _correoS}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          _numSeguidos = responseData['numSeguidos'].toString();
        });
      } else {
        print('Error al obtener los usuarios seguidos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
    }
  }

  Future<void> _fetchSeguidores() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarSeguidores/'),
        body: jsonEncode({'correo': _correoS}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          _numSeguidores = responseData['numSeguidores'].toString();
        });
      } else {
        print('Error al obtener los usuarios seguidores: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
    }
  }

  Future<void> _getUserPlaylists() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarPlaylistsUsuario/'),
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'correo': _correoS}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Response: $responseData');
        if (responseData.containsKey('playlists') && responseData['playlists'] != null) {
          final List<dynamic> playlistData = responseData['playlists'];
          final List<String> playlists = playlistData.map((data) => data['nombre'].toString()).toList();

          setState(() {
            _playlists = playlists;
          });
        } else {
          print('No se encontraron listas de reproducción para este usuario.');
        }
      } else {
        print('Else: Error al obtener las playlists: ${response.statusCode}');
      }
    } catch (e) {
      print('Catch: Error fetching user playlists: $e');
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
        title: const Text('Perfil', style: TextStyle(color: Colors.white))
        ,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: Colors.black),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      // Aquí colocas la imagen de la foto de perfil
                      radius: 50,
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

                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              // Lógica para editar el perfil
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => editarPerfil()),
                              );
                            },
                            child: Text('Editar perfil'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: Colors.black),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Alinea los botones horizontalmente
            children: [
              ElevatedButton(
                onPressed: () {
                  _fetchSeguidos();
                },
                child: Text('Seguidos: $_numSeguidos'),
              ),
              ElevatedButton(
                onPressed: () {
                  _fetchSeguidores();
                },
                child: Text('Seguidores: $_numSeguidores'),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _playlists.length,
              itemBuilder: (context, index) {
                final playlistName = _playlists[index];
                return ListTile(
                  title: Text(
                    playlistName,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildListTile(String title, String subtitle) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}