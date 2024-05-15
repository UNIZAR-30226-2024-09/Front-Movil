import 'dart:convert';

import 'package:aversifunciona/editarPerfil.dart';
import 'package:aversifunciona/getUserSession.dart';
import 'package:aversifunciona/listaSeguidos.dart';
import 'package:aversifunciona/listaSeguidores.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/perfilAjeno.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'biblioteca.dart';
import 'buscar.dart';
import 'chatSalaDisponible.dart';
import 'cola.dart';
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
                    ClipOval(
                      child: Image.asset(
                        'lib/panda.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
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
                                MaterialPageRoute(builder: (context) => EditarPerfil()),
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
          //SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start, // Alinea los botones horizontalmente
            children: [
              TextButton(
                onPressed: () {
                  // Lógica para navegar a la pantalla de seguidos
                  // Aquí debes añadir la navegación
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListaSeguidos()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                child: Text(
                  'Seguidos: $_numSeguidos',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Lógica para navegar a la pantalla de seguidores
                  // Aquí debes añadir la navegación
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListaSeguidores()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
                child: Text(
                  'Seguidores: $_numSeguidores',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Playlists',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 10), // Ajusta el valor según sea necesario para la posición deseada
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Cola()), // Suponiendo que Cola sea la pantalla a la que quieres navegar
            );
          },
          child: Icon(Icons.queue_music),
        ),
      ),

      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.white),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pantalla_principal()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Column(
                children: [
                  SizedBox(height: 8),
                  Icon(Icons.house_outlined, color: Colors.grey, size: 37.0),
                  Text(
                    'Inicio',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pantalla_buscar()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Column(
                children: [
                  SizedBox(height: 8),
                  Icon(Icons.question_mark_outlined, color: Colors.grey, size: 37.0),
                  Text(
                    'Buscar',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pantalla_biblioteca()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Column(
                children: [
                  SizedBox(height: 8),
                  Icon(Icons.library_books_rounded, color: Colors.grey, size: 37.0),
                  Text(
                    'Biblioteca',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pantalla_salas()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Column(
                children: [
                  SizedBox(height: 8),
                  Icon(Icons.chat_bubble_rounded, color: Colors.grey, size: 37.0),
                  Text(
                    'Salas',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
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