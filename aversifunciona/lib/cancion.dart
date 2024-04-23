//Creating a class user to store the data;
import 'package:flutter/material.dart';

class Cancion {
  final String nombre;
  final String miAlbum;
  final int puntuacion;
  final int numPuntuaciones;
  final List<int> archivo_mp3;
  final String foto;


  const Cancion({
    required this.nombre,
    required this.miAlbum,
    required this.puntuacion,
    required this.numPuntuaciones,
    required this.archivo_mp3,
    required this.foto
  });
}