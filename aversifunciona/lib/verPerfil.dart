import 'package:flutter/material.dart';

import 'EditarContrasena.dart';
import 'EditarCorreo.dart';
import 'EditarFechaNacimiento.dart';
import 'EditarNombreUsuario.dart';
import 'EditarPais.dart';
import 'EditarSexo.dart';


class verPerfil extends StatelessWidget {
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
          buildProfileItem(context, 'Nombre de usuario', 'Sinnuvva', EditarNombreUsuario()),
          buildProfileItem(context, 'Contraseña', '************', EditarContrasena()),
          // Agrega más opciones aquí según sea necesario
          buildProfileItem(context, 'Fecha de nacimiento', '19/02/2002', EditarFechaNacimiento()),
          buildProfileItem(context, 'Correo electrónico', 'sinnuvva@gmail.com', EditarCorreo()),
          buildProfileItem(context, 'Sexo', 'Femenino', EditarSexo()),
          buildProfileItem(context, 'País o región', 'España', EditarPais()),
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

