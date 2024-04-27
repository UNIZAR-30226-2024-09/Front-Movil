import 'dart:convert';

import 'package:aversifunciona/getUserSession.dart';
import 'package:flutter/material.dart';

import 'EditarContrasena.dart';
import 'EditarCorreo.dart';
import 'EditarFechaNacimiento.dart';
import 'EditarNombreUsuario.dart';
import 'EditarPais.dart';
import 'EditarSexo.dart';


class verPerfil extends StatefulWidget {
  @override
  _verPerfilState createState() => _verPerfilState();
}

class _verPerfilState extends State<verPerfil> {

  String _username = '';
  String _email = '';
  String _nacimiento = '';
  String _sexo = '';
  String _pais = '';

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
          _username = userInfo['nombre'];
          _email = userInfo['correo'];
          _nacimiento = userInfo['nacimiento'];
          _sexo = userInfo['sexo'];
          _pais = userInfo['pais'];
        });
      } else {
        print('Token is null');
      }
    } catch (e) {
      print('Error fetching user info: $e');
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
        title: const Text('Editar Perfil', style: TextStyle(color: Colors.white))
        ,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // Foto del usuario (puedes agregar la imagen del usuario aquí)
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // Puedes cambiar el color de fondo
              ),
              child: Center(
                child: Text(
                  'Foto del Usuario',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          // Opciones para editar
          buildProfileItem(context, 'Nombre de usuario', _username, EditarNombreUsuario()),
          buildProfileItem(context, 'Contraseña', '************', EditarContrasena()),
          // Agrega más opciones aquí según sea necesario
          buildProfileItem(context, 'Fecha de nacimiento', _nacimiento, EditarFechaNacimiento()),
          buildProfileItem(context, 'Correo electrónico', _email, EditarCorreo()),
          buildProfileItem(context, 'Sexo', _sexo, EditarSexo()),
          buildProfileItem(context, 'País o región', _pais, EditarPais()),
        ],
      ),
    );
  }

  Widget buildProfileItem(BuildContext context, String label, String value, Widget editScreen) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        value,
        style: TextStyle(color: Colors.grey),
      ),
      trailing: Icon(Icons.edit, color: Colors.white),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => editScreen),
        );
      },
    );
  }


}

