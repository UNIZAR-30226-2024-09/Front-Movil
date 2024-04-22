import 'package:flutter/material.dart';
import 'chatDeSala.dart';

class crearSala extends StatelessWidget {
  TextEditingController salaController = TextEditingController();

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
        title: const Text(
          'Salas',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              buildButton('+', Colors.grey, 'Crear sala', () {
                // Abre el cuadro de diálogo al presionar el botón
                _showCreateRoomDialog(context);
              }),
              buildButton('SpainMusic', Colors.blue, 'Únete ahora', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDeSala(roomName: 'SpainMusic')));
              }),
              buildButton('SiaLovers', Colors.blue, 'Únete ahora', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDeSala(roomName: 'SiaLovers')));
              }),
              buildButton('EminemGroup', Colors.blue, 'Únete ahora', () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDeSala(roomName: 'EminemGroup')));
              }),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  // Contenido principal (puedes colocar aquí tu imagen o cualquier otro contenido)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(String label, Color color, String buttonText, VoidCallback onPressed) {
    return Container(
      width: 300, // Ancho fijo
      height: 100,  // Alto fijo
      margin: const EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              buttonText,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: 300,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Nombre de la Sala',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: salaController,
                  decoration: InputDecoration(
                    hintText: 'Ingrese el nombre de la sala',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Puedes acceder al nombre de la sala usando salaController.text
                    // Agrega aquí la lógica para crear la sala con el nombre proporcionado
                    String roomName = salaController.text;
                    // Lógica para crear la sala
                    Navigator.pop(context); // Cerrar el diálogo
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDeSala(roomName: roomName)));
                  },
                  child: Text('Aceptar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
