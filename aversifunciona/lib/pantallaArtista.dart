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
  Map<String, dynamic> artistaData = {};
  List<dynamic> canciones = []; // Lista para almacenar las canciones del artista

  @override
  void initState() {
    super.initState();
    _fetchArtistaData();
    _fetchCanciones();
  }

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

  /*Future<void> _fetchCanciones() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarCancionesArtista/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'artistaId': widget.artistaId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          canciones = responseData['canciones']; // Obtener las canciones del artista
        });
      } else {
        throw Exception('Error al obtener las canciones del artista');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al obtener las canciones del artista'),
        ),
      );
    }
  }*/

  Future<void> _fetchCanciones() async {
    try {
      final response = await http.post(
        Uri.parse('${Env.URL_PREFIX}/listarCancionesArtista/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'artistaId': widget.artistaId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          canciones = responseData['canciones']; // Obtener las canciones del artista
        });
      } else {
        throw Exception('Error al obtener las canciones del artista');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al obtener las canciones del artista'),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Canciones del artista:',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), // Deshabilitar el desplazamiento de la lista interna
                  itemCount: canciones.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          FutureBuilder<Uint8List>(
                            future: _fetchImageFromUrl('${Env.URL_PREFIX}/imagenCancion/${canciones[index]['id']}/'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return CircleAvatar(
                                  radius: 30,
                                  backgroundImage: MemoryImage(snapshot.data!),
                                );
                              }
                            },
                          ),
                          SizedBox(width: 20),
                          Text(
                            canciones[index]['nombre'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
