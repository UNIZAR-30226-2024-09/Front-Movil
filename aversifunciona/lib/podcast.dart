import 'package:flutter/material.dart';

class Podcast {
  final int? id;
  final String nombre;
  //final int? puntuacion;
  //final int? numPuntuaciones;
  final String foto;


  const Podcast({
    required this.id,
    required this.nombre,
    //required this.puntuacion,
    //required this.numPuntuaciones,
    required this.foto
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('id') &&
        json.containsKey('nombre') &&
        //json.containsKey('puntuacion') &&
        //json.containsKey('numPuntuaciones') &&
        json.containsKey('foto')) {
      return Podcast(
        id: json['id'] as int?,
        nombre: json['nombre'] as String,
        //puntuacion: json['puntuacion'] as int?,
        //numPuntuaciones: json['numPuntuaciones'] as int?,
        foto: json['foto'] as String,
      );
    } else {
      throw const FormatException('Failed to load podcast.');
    }
  }

  @override
  String toString() {
    return 'Podcast(id: $id, nombre: $nombre, foto: $foto)';
  }

}