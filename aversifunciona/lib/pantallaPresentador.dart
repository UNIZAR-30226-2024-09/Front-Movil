import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'package:aversifunciona/getUserSession.dart';

import 'historialAjeno.dart';

class PantallaPresentador extends StatefulWidget {
  final int presentadorId;
  final String presentadorName;

  PantallaPresentador({required this.presentadorId, required this.presentadorName});

  @override
  _PantallaPresentadorState createState() => _PantallaPresentadorState();
}

class _PantallaPresentadorState extends State<PantallaPresentador> {
  String _nombreS = '';
  String _correoS = '';
  Map<String, dynamic> presentadorData = {};

  @override
  void initState() {
    super.initState();
    _fetchPresentadorData();
  }

  Future<void> _fetchPresentadorData() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/devolverPresentador/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'presentadorId': widget.presentadorId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        presentadorData = responseData['presentador'];
        setState(() {
          _nombreS = presentadorData['nombre']; // Obtener el nombre del artista
        });

      } else {
        throw Exception('Error al obtener los datos del presentador');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al obtener los datos del presentador'),
        ),
      );
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
        title: const Text('Presentador', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('${Env.URL_PREFIX}/imagenPresentador/${presentadorData['id']}/'), // Usar la URL de la imagen del perfil
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nombreS,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class PlaylistItem extends StatelessWidget {
  final String name;
  final String imageUrl;

  PlaylistItem({required this.name, required this.imageUrl});

  Future<Uint8List> _fetchImageFromUrl(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      // Devuelve los bytes de la imagen
      return response.bodyBytes;
    } else {
      // Si la solicitud falla, lanza un error
      throw Exception('Failed to load image from $imageUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [

          SizedBox(width: 20),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),

          ),

        ],

      ),

    );

  }

}
