import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'package:aversifunciona/getUserSession.dart';

import 'historialAjeno.dart';

class PerfilAjeno extends StatefulWidget {
  final Map<String, dynamic> usuario;

  PerfilAjeno({required this.usuario});

  @override
  _PerfilAjenoState createState() => _PerfilAjenoState();
}

class _PerfilAjenoState extends State<PerfilAjeno> {
  String _nombreS = '';
  String _correoSeguidoS = '';
  List<String> _playlists = [];
  String _numSeguidos = '0';
  String _numSeguidores = '0';
  bool isFollowing = false;
  String _correoS = '';

  @override
  void initState() {
    super.initState();
    if (widget.usuario.containsKey('seguido')) {
      _devolverUsuario(widget.usuario['seguido']);
    } else if(widget.usuario != null) {
      print('el nombre del ususario es ${widget.usuario['nombre']}');
      _devolverUsuario(widget.usuario['correo']);
    } else {
      print('El usuario pasado al perfil es nulo o no contiene la clave "seguido".');
      // Aquí puedes manejar el caso en el que el usuario es nulo o no contiene la clave esperada.
    }
  }



  void toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
    });
    if (isFollowing) {
      _seguirUsuario(); // Llama a la función para seguir al usuario
    } else {
      _dejarDeSeguirUsuario(); // Llama a la función para dejar de seguir al usuario
    }
  }

  void _seguirUsuario() async {
    try {
      String correoAux;
      if (widget.usuario.containsKey('seguido')) {
        correoAux = widget.usuario['seguido'];
      } else {
        correoAux = widget.usuario['correo'];
      }
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/seguir/'),
        body: jsonEncode({
          'correo': _correoS, // Correo del usuario actual
          'seguido': correoAux, // Correo del usuario del perfil
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Usuario seguido con éxito');
      } else {
        print('Error al seguir al usuario: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
    }
  }

  void _dejarDeSeguirUsuario() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/dejarDeSeguir/'),
        body: jsonEncode({
          'correo': _correoS, // Correo del usuario actual
          'seguido': widget.usuario['seguido'], // Correo del usuario del perfil
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Usuario dejado de seguir con éxito');
      } else {
        print('Error al dejar de seguir al usuario: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
    }
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
        _comprobarSiguiendo();
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
          _correoSeguidoS = usuario['correo'];
        });
        _fetchSeguidosSeguidores();
        _getUserPlaylists();
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

  Future<void> _fetchSeguidosSeguidores() async {
    try {
      final responseSeguidos = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarSeguidos/'),
        body: jsonEncode({'correo': _correoSeguidoS}),
        headers: {'Content-Type': 'application/json'},
      );

      final responseSeguidores = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarSeguidores/'),
        body: jsonEncode({'correo': _correoSeguidoS}),
        headers: {'Content-Type': 'application/json'},
      );

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
        body: jsonEncode({'correo': _correoSeguidoS}),
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

  Future<void> _comprobarSiguiendo() async {
    try {
      print('Correo usuario: $_correoS - Correo seguido: $_correoSeguidoS');
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/siguiendo/'),
        body: jsonEncode({
          'correo': _correoS, // Correo del usuario actual
          'esSeguido': _correoSeguidoS, // Correo del usuario del perfil
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final bool siguiendo = responseData['siguiendo'];
        setState(() {
          isFollowing = siguiendo; // Actualizar el estado de isFollowing
        });
        print('Siguiendo: $siguiendo');
      } else {
        print('Error al comprobar si sigue al usuario: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud HTTP: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final nombre = widget.usuario['nombre'] ?? '';
    final correo = widget.usuario['correo'] ?? '';
    final seguidores = widget.usuario['seguidores'] ?? '';
    final siguiendo = widget.usuario['siguiendo'] ?? '';

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
        title: const Text('Perfil', style: TextStyle(color: Colors.white)),
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
                    child: ClipOval(
                      child: Image.asset(
                        'lib/panda2.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
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
                      Row(
                        children: [
                          Text(
                            'Seguidores: $_numSeguidores',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            seguidores.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            'Siguiendo: $_numSeguidos',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            siguiendo.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: isFollowing
                  ? OutlinedButton(
                onPressed: toggleFollow,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.white),
                ),
                   child: Text(
                    'Siguiendo',
                    style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
                  : ElevatedButton(
                onPressed: toggleFollow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  'Seguir',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
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
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
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
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => historialAjeno(correoSeguidoS: _correoSeguidoS)), // Pasa el usuario al constructor de la pantalla historial.dart
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.white),
                  ),
                ),
                child: Text('Ver historial'),
              ),
            ),
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
