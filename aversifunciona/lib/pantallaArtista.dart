import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'package:aversifunciona/getUserSession.dart';

import 'historialAjeno.dart';

class PantallaArtista extends StatefulWidget {
  final int artistaId;
  final String artistaName;

  PantallaArtista({required this.artistaId, required this.artistaName});

  @override
  _PantallaArtistaState createState() => _PantallaArtistaState();
}

class _PantallaArtistaState extends State<PantallaArtista> {
  String _nombreS = '';
  String _correoS = '';
  Map<String, dynamic> artistaData = {};

  @override
  void initState() {
    super.initState();
    _fetchArtistaData();
  }

  Future<void> _fetchArtistaData() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/devolverArtista/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'artistaId': widget.artistaId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        artistaData = responseData['artista'];
        setState(() {
          _nombreS = artistaData['nombre']; // Obtener el nombre del artista
        });

      } else {
        throw Exception('Error al obtener los datos del artista');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al obtener los datos del artista'),
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
        title: const Text('Artista', style: TextStyle(color: Colors.white)),
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
                    backgroundImage: NetworkImage('${Env.URL_PREFIX}/imagenArtista/${artistaData['id']}/'), // Usar la URL de la imagen del perfil
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
          /*child: FutureBuilder<Uint8List>(
            future: _fetchImageFromUrl('${Env.URL_PREFIX}/imagenArtista/${artista['id']}/'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Muestra un indicador de carga mientras se decodifica la imagen
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Muestra un mensaje de error si ocurre un error durante la decodificación
                return Text('Error: ${snapshot.error}');
              } else {
                // Si la decodificación fue exitosa, muestra la imagen
                return Image.memory(
                  snapshot.data!,
                  height: 80, // Tamaño fijo para la imagen
                  width: 80, // Tamaño fijo para la imagen
                  fit: BoxFit.cover,

                );
              }
            },
          ),*/

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