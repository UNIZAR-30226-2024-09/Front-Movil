import 'dart:convert';
import 'package:aversifunciona/biblioteca.dart';
import 'package:aversifunciona/buscar.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/salas.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;
import 'package:aversifunciona/getUserSession.dart';
import 'env.dart';

class Sala {
  final int id;
  final String nombre;

  Sala({
    required this.id,
    required this.nombre,
  });
}



class ChatDeSala extends StatefulWidget {
  final int idDeLaSala;

  ChatDeSala({required this.idDeLaSala});

  @override
  _ChatDeSalaState createState() => _ChatDeSalaState();
}

class _ChatDeSalaState extends State<ChatDeSala> {
  TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  Sala _sala = Sala(id: -1, nombre: "");
  String userId = '-1';
  String _correo = '';
  late IOWebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    _channel = IOWebSocketChannel.connect('ws://localhost:8000/ws');
    _loadMessages(); // Cargar mensajes al iniciar la pantalla del chat
    _channel.stream.listen((message) {
      setState(() {
        _messages.add(message);
        _saveMessage(message); // Guardar el nuevo mensaje recibido
      });
    });
  }

  Future<void> obtenerUsuario(String correo) async {
    try {
      var url = Uri.parse('${Env.URL_PREFIX}/DevolverUsuarioAPI/');
      var response = await http.post(
        url,
        body: jsonEncode({'correo': correo}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        Map<String, dynamic> data = jsonDecode(response.body);
        userId = data['usuario'];
      } else if (response.statusCode == 404) {
        // El usuario no existe
        print('El usuario no existe');
      } else {
        // Manejar otros códigos de estado
        print('Error al obtener el usuario: ${response.statusCode}');
      }
    } catch (error) {
      // Manejar errores de red u otros errores
      print('Error: $error');
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
          _correo = userInfo['correo'];
        });
      } else {
        print('Token is null');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  void _sendMessage(String message) {
    _channel.sink.add(message);
    _messageController.clear();
    _getUserInfo();
    obtenerUsuario(_correo);
    _saveMessage(message); // Guardar el mensaje enviado por el usuario
  }

  @override
  void dispose() {
    // Cierra la conexión cuando la pantalla se destruye
    _channel.sink.close();
    super.dispose();
  }


  Future<void> _loadMessages() async {
    try {
      var url = Uri.parse('${Env.URL_PREFIX}/CargarMensajesAPI/');
      var response = await http.post(
        url,
        body: jsonEncode({'salaid': widget.idDeLaSala}), // Reemplaza 'idDeLaSala' con el ID real de la sala
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Obtener información sobre la sala
        Map<String, dynamic> salaData = data['miSala'];
        Sala sala = Sala(
          id: salaData['id'],
          nombre: salaData['nombre'],
        );

        // Obtener mensajes
        List<dynamic> mensajesData = data['mensajes'];
        List<Map<String, dynamic>> mensajes = mensajesData.map((message) {
          return {
            "texto": message['texto'], // Obtener el texto del mensaje
            "autor": message['miUsuario'], // Obtener el autor del mensaje
          };
        }).toList();

        // Actualizar el estado
        setState(() {
          _sala = sala;
          _messages = mensajes;
          _messages = _messages.reversed.toList(); // Invertir la lista para mostrar los mensajes más recientes al final
        });

      } else if (response.statusCode == 404) {
        // Mostrar un mensaje si la sala no existe
        print('La sala no existe');
      } else {
        // Manejar otros códigos de estado
        print('Error al cargar los mensajes: ${response.statusCode}');
      }
    } catch (error) {
      // Manejar errores de red u otros errores
      print('Error: $error');
    }
  }



  Future<void> _saveMessage(String message) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int idDeLaSala = widget.idDeLaSala;
      String emisorId = userId;

      var url = Uri.parse('${Env.URL_PREFIX}/RegistrarMensajeAPI/');
      var response = await http.post(
        url,
        body: jsonEncode({
          'salaid': idDeLaSala,
          'emisorid': emisorId,
          'mensaje': message,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Mensaje registrado con éxito');
      }else if (response.statusCode == 404) {
        print('El emisor o la sala no existen.');
      } else {
        // Manejar otros códigos de estado
        print('Error al guardar el mensaje: ${response.statusCode}');
      }
    } catch (error) {
      // Manejar errores de red u otros errores
      print('Error: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        title: Text(
          _sala.nombre,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Color(0xFF333333),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages.reversed.toList()[index];
                    final isCurrentUser = message['miUsuario'] == userId; // comparamos el propietario de un mensaje con el usuario actual
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: isCurrentUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (isCurrentUser)
                            Text(
                              "Tú:",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          else
                            Text(
                              message['miUsuario'] + ':',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          Align(
                            alignment: isCurrentUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isCurrentUser ? Colors.blue : Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${message['text']}",
                                style: TextStyle(
                                  color: isCurrentUser ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              color: Colors.black,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                controller: _messageController,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  hintText: 'Escribe un mensaje...',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String message = _messageController.text;
                          _sendMessage(_messageController.text);
                          _messageController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Enviar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
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
                          child: Column(
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
                          child: Column(
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
                          child: Column(
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
                          child: Column(
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
            ),
          ],
        ),
      ),
    );
  }
}
