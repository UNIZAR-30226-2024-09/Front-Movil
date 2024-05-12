import 'package:flutter/material.dart';
import 'dart:typed_data';

class Cancion {
  final int? id;
  final String nombre;
  final int? miAlbum;
  final int? puntuacion;
  final Uint8List? archivomp3;
  final Uint8List? foto;


  const Cancion({
    required this.id,
    required this.nombre,
    required this.miAlbum,
    required this.puntuacion,
    required this.archivomp3,

    required this.foto
  });

  factory Cancion.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('id') &&
        json.containsKey('nombre') &&
        json.containsKey('miAlbum') &&
        json.containsKey('puntuacion') &&
        json.containsKey('archivoMp3') &&
        json.containsKey('foto')) {
      return Cancion(
        id: json['id'] as int?,
        nombre: json['nombre'] as String,
        miAlbum: json['miAlbum'] as int?,
        puntuacion: json['puntuacion'] as int?,
        archivomp3: json['archivoMp3'] as Uint8List?,
        foto: json['foto'] as Uint8List?,
      );
    } else {
      throw const FormatException('Failed to load album.');
    }
  }
}