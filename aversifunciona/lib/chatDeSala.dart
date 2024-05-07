import 'package:aversifunciona/biblioteca.dart';
import 'package:aversifunciona/buscar.dart';
import 'package:aversifunciona/pantalla_principal.dart';
import 'package:aversifunciona/salas.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';


class ChatDeSala extends StatefulWidget {
  final String roomName;
  final String userName;

  ChatDeSala({required this.roomName, required this.userName});

  @override
  _ChatDeSalaState createState() => _ChatDeSalaState();
}

class _ChatDeSalaState extends State<ChatDeSala> {
  TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> _messages = [];
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

  void _sendMessage(String message) {
    _channel.sink.add(message);
    _messageController.clear();
    _saveMessage(message); // Guardar el mensaje enviado por el usuario
  }

  @override
  void dispose() {
    // Cierra la conexión cuando la pantalla se destruye
    _channel.sink.close();
    super.dispose();
  }


  Future<void> _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _messages = (prefs.getStringList('chat_messages_${widget.roomName}') ?? [])
          .map((message) => {"text": message, "name": widget.userName})
          .toList();
      _messages = _messages.reversed.toList(); // Reverse the list to display recent messages at the bottom
    });
  }

  Future<void> _saveMessage(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updatedMessages =
    [..._messages.map((msg) => msg["text"] ?? ""), message];
    await prefs.setStringList(
        'chat_messages_${widget.roomName}', updatedMessages);
    setState(() {
      _messages = [
        {"text": message, "name": widget.userName},
        ..._messages, // Add new message at the beginning of the list
      ];
    });

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
          widget.roomName,
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
                    final isCurrentUser = message["name"] == widget.userName;
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
                              widget.userName + ':',
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
                          _saveMessage(message);
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
