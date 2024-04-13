import 'package:http/http.dart' as http;
import 'dart:convert';

import 'env.dart';

Future<bool> registroValido(String nombre, String correo, String contrasegna, String fecha, String pais, bool politicaAceptada) async {
  try {
    final response = await http.post(
      Uri.parse("${Env.URL_PREFIX}/registro/"), // Ajusta la URL según tu API
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{
        'nombre': nombre,
        'correo': correo,
        'contrasegna': contrasegna,
        'fecha': fecha,
        'pais': pais,
      }),
    );

    if (response.statusCode == 200) {
      // Si la solicitud es exitosa, retornar verdadero
      return true;
    } else {
      // Si la solicitud no es exitosa, retornar falso
      return false;
    }
  } catch (e) {
    // Si ocurre algún error, retornar falso
    print("Error al realizar la solicitud HTTP: $e");
    return false;
  }
}
