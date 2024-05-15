import 'dart:convert';

import 'package:aversifunciona/getUserSession.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'EditarContrasena.dart';
import 'EditarCorreo.dart';
import 'EditarFechaNacimiento.dart';
import 'EditarNombreUsuario.dart';
import 'EditarPais.dart';
import 'EditarSexo.dart';
import 'env.dart';

class EditarPerfil extends StatefulWidget {
  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {

  String _nombreS = '';
  String _correoS = '';
  String _nacimientoS = '';
  String _sexoS = '';
  String _paisS = '';
  String _contrasegnaS = '';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    try {
      String? token = await getUserSession.getToken();
      print("Token: $token");
      if (token != null) {
        Map<String, dynamic> userInfo = await getUserSession.getUserInfo(token);
        setState(() {
          _nombreS = userInfo['nombre'];
          _correoS = userInfo['correo'];
          _nacimientoS = userInfo['nacimiento'];
          _sexoS = userInfo['sexo'];
          _paisS = userInfo['pais'];
          _contrasegnaS = userInfo['contrasegna'] ?? ''; // Verifica si la contraseña es nula
        });
      } else {
        print('Token is null');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<bool> actualizarUsuario(TextEditingController nombre, TextEditingController sexo, TextEditingController nacimiento,
      TextEditingController contrasegna, TextEditingController pais) async {
    String contrasegnaAux = contrasegna.text != "" ? contrasegna.text : _contrasegnaS;

    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/actualizarUsuario/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          'correo': _correoS,
          'nombre': nombre.text,
          'sexo': sexo.text,
          'nacimiento': nacimiento.text,
          'contrasegna': contrasegnaAux,
          'pais': pais.text,
        }),
      );

      if (response.statusCode == 200) {
        return true; // Cambios guardados correctamente
      } else {
        return false; // Error al guardar los cambios
      }
    } catch (e) {
      print("Error al realizar la solicitud HTTP: $e");
      return false; // Error al guardar los cambios
    }
  }


  @override
  Widget build(BuildContext context) {
    TextEditingController _nombre = TextEditingController(text: _nombreS);
    TextEditingController _sexo = TextEditingController(text: _sexoS);
    TextEditingController _nacimiento = TextEditingController(text: _nacimientoS);
    TextEditingController _contrasegna = TextEditingController(text: _contrasegnaS);
    TextEditingController _pais = TextEditingController(text: _paisS);
    TextEditingController _correo = TextEditingController(text: _correoS);

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
        title: const Text('Editar Perfil', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(
                child: Image.asset(
                  'lib/panda.jpg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Nombre de usuario',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: TextField(
                controller: _nombre,
                style: TextStyle(color: Colors.grey),
              ),
            ),

            ListTile(
              title: Text(
                'Contraseña',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: TextField(
                controller: _contrasegna,
                style: TextStyle(color: Colors.grey),
              ),
            ),

            ListTile(
              title: Text(
                'Fecha de nacimiento',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: TextField(
                controller: _nacimiento,
                style: TextStyle(color: Colors.grey),
              ),
            ),

            ListTile(
              title: Text(
                'Correo electrónico',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No se puede cambiar el correo electrónico'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: _correo,
                    style: TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      hintText: 'No se puede cambiar',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),

            ListTile(
              title: Text(
                'Sexo',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: TextField(
                controller: _sexo,
                style: TextStyle(color: Colors.grey),
              ),
            ),

            ListTile(
              title: Text(
                'País o región',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: TextField(
                controller: _pais,
                style: TextStyle(color: Colors.grey),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _getUserInfo();
                  },
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool cambiosGuardados = await actualizarUsuario(_nombre, _sexo, _nacimiento, _contrasegna, _pais);
                    if (cambiosGuardados) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Cambios guardados correctamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al guardar los cambios'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text('Guardar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
