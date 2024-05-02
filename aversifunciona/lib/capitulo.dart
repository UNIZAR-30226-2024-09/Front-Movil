import 'package:flutter/material.dart';

class Capitulo {
  final int? id;
  final String nombre;
  final String? descripcion;
  final int? miPodcast;
  final String? archivomp3;


  const Capitulo({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.miPodcast,
    required this.archivomp3,
  });

  factory Capitulo.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('id') &&
        json.containsKey('nombre') &&
        json.containsKey('descripcion') &&
        json.containsKey('miPodcast') &&
        json.containsKey('archivoMp3')) {
      return Capitulo(
        id: json['id'] as int?,
        nombre: json['nombre'] as String,
        descripcion: json['descripcion'] as String?,
        miPodcast: json['miPodcast'] as int?,
        archivomp3: json['archivoMp3'] as String?,
      );
    } else {
      throw const FormatException('Failed to load podcast.');
    }
  }
}