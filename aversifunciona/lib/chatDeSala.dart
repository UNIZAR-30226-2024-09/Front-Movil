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
  ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  Sala _sala = Sala(id: -1, nombre: "");
  String userEmail = '';
  late IOWebSocketChannel _channel;
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _connectToWebSocket();
    setState(() {
      _isLoading = true;
    });
    _loadMessages().then((_) {
      // Desplazar la lista al final
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    setState(() {
      _isLoading = false;
    });

  }

  // Escuchar mensajes entrantes a través del WebSocket
  void _connectToWebSocket() {
    _channel = IOWebSocketChannel.connect('ws://localhost:8000/ws/chat/${widget.idDeLaSala}/');
    _channel.stream.listen((message) {
      setState(() {
        _messages.add({
          'cuerpo': {
            'mensaje': message['cuerpo']['mensaje'],
            'emisorid': message['cuerpo']['emisorid'],
          },
        });
      });
    });
  }

  /*Future<void> obtenerUsuario(String correo) async {
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
        debugPrint('El usuario no existe');
      } else {
        // Manejar otros códigos de estado
        debugPrint('Error al obtener el usuario: ${response.statusCode}');
      }
    } catch (error) {
      // Manejar errores de red u otros errores
      debugPrint('Error: $error');
    }
  }*/

  Future<void> _getUserInfo() async {
    try {
      String? token = await getUserSession.getToken(); // Espera a que el token se resuelva
      debugPrint("Token: $token");
      if (token != null) {
        // Llama al método AuthService para obtener la información del usuario
        Map<String, dynamic> userInfo = await getUserSession.getUserInfo(token);
        debugPrint(userInfo.toString());
        setState(() {
          userEmail = userInfo['correo'];
        });
        debugPrint(userEmail);

      } else {
        debugPrint('Token is null');
      }
    } catch (e) {
      debugPrint('Error fetching user info: $e');
    }
  }

  void _sendMessage(String message) {
    Map<String, dynamic> messageData = {
      'cuerpo': {
        'mensaje': message,
        'emisorid': userEmail,
        'salaid': widget.idDeLaSala,
      }
    };
    String messageToSend = jsonEncode(messageData);
    _channel.sink.add(messageToSend); // Guardar el mensaje enviado por el usuario en el canal para que les llegue al resto de usuarios en el momento actual
    _saveMessage(message); // Guardar el mensaje enviado por el usuario en la base de datos
    _loadMessages();
  }

  @override
  void dispose() {
    // Cierra la conexión cuando la pantalla se destruye
    _channel.sink.close();
    super.dispose();
  }


  Future<void> _loadMessages() async {
    try {
      var url = Uri.parse('${Env.URL_PREFIX}/cargarMensajesAPI/');
      var response = await http.post(
        url,
        body: jsonEncode({'salaid': widget.idDeLaSala}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, dynamic>> mensajesData = data.map((message) {
          return {
            "texto": message['texto'],
            "miUsuario": message['miUsuario'],
          };
        }).toList();

        setState(() {
          _messages = mensajesData.toList();
          _isLoading = false;
        });

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else if (response.statusCode == 404) {
        debugPrint('La sala no existe');
      } else {
        debugPrint('Error al cargar los mensajes: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error loadMessages: $error');
    }
  }
  Future<void> _saveMessage(String message) async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      int idDeLaSala = widget.idDeLaSala;
      String emisorId = userEmail;

      var url = Uri.parse('${Env.URL_PREFIX}/registrarMensajeAPI/');

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
        debugPrint('Mensaje registrado con éxito');
        await _loadMessages();
      }else if (response.statusCode == 404) {
        debugPrint('El emisor o la sala no existen.');
      } else {
        // Manejar otros códigos de estado
        debugPrint('Error al guardar el mensaje: ${response.statusCode}');
      }
    } catch (error) {
      // Manejar errores de red u otros errores
      debugPrint('Error: $error');
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
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        title: Text(
          _sala.nombre,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      ) : Container(
        color: const Color(0xFF333333),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {

                    final message = _messages[index];
                    final isCurrentUser = message['miUsuario'] == userEmail; // comparamos el propietario del mensaje que estamos tratando con el usuario actual
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: isCurrentUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (isCurrentUser)
                            const Text(
                              "Tú:",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          else
                            Text(
                              message['miUsuario'] + ':',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          Align(
                            alignment: isCurrentUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isCurrentUser ? Colors.blue : Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${message['texto']}",
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
                                style: const TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
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
                          setState(() {
                            _isLoading = true;
                          });
                          _sendMessage(message);
                          setState(() {
                            _isLoading = false;
                          });
                          _messageController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Enviar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
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
            ),
          ],
        ),
      ),
    );
  }
}
