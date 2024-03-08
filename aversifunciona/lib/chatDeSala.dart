import 'package:flutter/material.dart';

class ChatDeSala extends StatefulWidget {
  @override
  _ChatDeSalaState createState() => _ChatDeSalaState();
}

class _ChatDeSalaState extends State<ChatDeSala> {
  TextEditingController _messageController = TextEditingController();
  List<String> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Título de la pantalla',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // Botón Todo
          buildTopButton('Todo'),

          // Botón Música
          buildTopButton('Música'),

          // Botón Podcast
          buildTopButton('Podcast'),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: ListView.builder(
                reverse: true, // Muestra los mensajes más recientes arriba
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _messages[index],
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.white),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _messageController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _messages.add(_messageController.text);
                      _messageController.clear();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Colors.grey,
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
          ),
        ],
      ),
    );
  }

  Widget buildTopButton(String title) {
    return Container(
      margin: EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () {
          // Acción al presionar el botón (puedes personalizarlo según sea necesario)
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class pantalla_salas extends StatelessWidget {
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
        title: Text(
          'Salas',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          buildButton('+', Colors.grey, 'Crear sala', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDeSala()));
          }),
          buildButton('SpainMusic', Colors.blue, 'Únete ahora', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDeSala()));
          }),
          buildButton('SiaLovers', Colors.blue, 'Únete ahora', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDeSala()));
          }),
          buildButton('EminemGroup', Colors.blue, 'Únete ahora', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDeSala()));
          }),
          // ... (Resto del código)
        ],
      ),
    );
  }

  Widget buildButton(String label, Color color, String buttonText, VoidCallback onPressed) {
    return Container(
      width: 300, // Ancho fijo
      height: 100,  // Alto fijo
      margin: EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              buttonText,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

