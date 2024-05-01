import 'dart:convert';

import 'package:aversifunciona/FAQprincipal.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/salas.dart';
import 'package:aversifunciona/verPerfil.dart';
import 'package:flutter/material.dart';
import 'package:aversifunciona/getUserSession.dart';
import 'package:aversifunciona/inicioSesion.dart';

import 'biblioteca.dart';
import 'buscar.dart';

import 'package:http/http.dart' as http;

import 'env.dart';

class configuracion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 10),
            Text('Configuración', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, // Eliminar el botón de retroceso predeterminado
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Container(
            height: 70,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.white),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Opción de perfil del usuario
                InkWell(
                  onTap: () {
                    // Lógica para manejar el tap en la opción del perfil del usuario
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => verPerfil()),
                    );
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        // Aquí deberías proporcionar la imagen del perfil del usuario
                        backgroundColor: Colors.grey,
                        radius: 20,
                        // Supongamos que la imagen del perfil se llama 'user_profile.jpg' y está en la carpeta de activos
                        backgroundImage: AssetImage('assets/user_profile.jpg'),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Nombre de Usuario', // Deberías reemplazar esto con el nombre del usuario
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward, color: Colors.white),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                buildOption(context, "Ver perfil", Icon(Icons.arrow_forward)),
                buildOption(context, "Cuenta", Icon(Icons.arrow_forward)),
                buildOption(context, "Ayuda", Icon(Icons.arrow_forward)),

              ],
            ),
          ),
          //SizedBox(height: 20),
          Container(
            height: 70,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.black),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String? token = await getUserSession.getToken();
                    print("token para cerrar sesión: $token");
                    // Lógica para cerrar sesión
                    final response = await http.post(
                        Uri.parse('${Env.URL_PREFIX}/cerrarSesionAPI/'),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode({'token': token})
                    );

                    if (response.statusCode == 200) {
                      // Elimina el token de autenticación almacenado localmente
                      // Aquí deberías implementar la lógica para eliminar el token

                      // Redirige al usuario a la pantalla de inicio de sesión
                      //Navigator.pushReplacementNamed(context, '/inicioSesion/');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InicioSesion()),
                      );
                    } else {
                      // Muestra un mensaje de error si falla la solicitud
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al cerrar sesión'),
                        ),
                      );
                    }
                  },
                  child: Text('Cerrar sesión'),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
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
        ],
      ),
    );
  }

  Widget buildOption(BuildContext context, String title, Widget trailingIcon) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      trailing: trailingIcon,
      onTap: () {
        // Lógica para manejar el tap en cada opción
        if (title == "Cuenta") {
          // Navegar a la pantalla de cuenta
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => verPerfil()),
          );
        } else if (title == "Ayuda") {
          // Navegar a la pantalla de ayuda
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FAQprincipal()),
          );
        }
      },
    );
  }
}
