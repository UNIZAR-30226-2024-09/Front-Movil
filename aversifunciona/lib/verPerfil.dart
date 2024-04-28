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

class verPerfil extends StatefulWidget {
  @override
  _verPerfilState createState() => _verPerfilState();
}

class _verPerfilState extends State<verPerfil> {

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
      String? token = await getUserSession.getToken(); // Espera a que el token se resuelva
      print("Token: $token");
      if (token != null) {
        // Llama al método AuthService para obtener la información del usuario
        Map<String, dynamic> userInfo = await getUserSession.getUserInfo(token);
        setState(() {
          _nombreS = userInfo['nombre'];
          _correoS = userInfo['correo'];
          _nacimientoS = userInfo['nacimiento'];
          _sexoS = userInfo['sexo'];
          _paisS = userInfo['pais'];
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
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/actualizarUsuario/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          // Aquí envía los datos que deseas actualizar, por ejemplo:
          // 'nombre': _nuevoNombreUsuarioController.text,
          // 'contrasena': _nuevaContrasenaController.text,
          // 'fecha_nacimiento': _nuevaFechaNacimientoController.text,
          // 'correo': _nuevoCorreoController.text,
          // Y así sucesivamente para cada campo que desees actualizar
          'correo': _correoS,
          'nombre': nombre.text,
          'sexo': sexo.text,
          'nacimiento': nacimiento.text,
          'contrasegna': contrasegna.text,
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

          //buildProfileItem(context, 'Nombre de usuario', _username, EditarNombreUsuario()),
          //TextEditingController _controller = TextEditingController(text: value);
          ListTile(
            title: Text(
              'Nombre de usuario',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: TextField(
              controller: _nombre,
              style: TextStyle(color: Colors.grey),
            ),
            /*trailing: Icon(Icons.edit, color: Colors.white),
            onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => editScreen),
                );
              },*/
            ),

          //buildProfileItem(context, 'Contraseña', '', EditarContrasena()),
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

          //buildProfileItem(context, 'Fecha de nacimiento', _nacimientoS, EditarFechaNacimiento()),
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

          //buildProfileItem(context, 'Correo electrónico', _correoS, EditarCorreo()),
          ListTile(
            title: Text(
              'Correo electrónico',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: TextField(
              controller: _correo,
              style: TextStyle(color: Colors.grey),
            ),
          ),

          //buildProfileItem(context, 'Sexo', _sexoS, EditarSexo()),
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

          //buildProfileItem(context, 'País o región', _paisS, EditarPais()),
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
                  // Lógica para cancelar los cambios
                },
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Lógica para aceptar los cambios
                  bool cambiosGuardados = await actualizarUsuario(_nombre, _sexo, _nacimiento, _contrasegna, _pais);
                  if (cambiosGuardados) {
                    // Mostrar mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cambios guardados correctamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    // Mostrar mensaje de error
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
    );
  }

  /*
  Widget buildProfileItem(BuildContext context, String label, String value, Widget editScreen) {
    TextEditingController _controller = TextEditingController(text: value);
    return ListTile(
      title: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: TextField(
        controller: _controller,
        //decoration: InputDecoration(
          //labelText: value,
        //),
        //value,
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
*/
}

