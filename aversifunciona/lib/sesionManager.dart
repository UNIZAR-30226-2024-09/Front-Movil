import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future<void> saveUserSession({
    required String email,
    required String password,
    String? fecha,
    String? pais,
    String? genero,
    String? nombre,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
    await prefs.setString('userPassword', password);
    if (fecha != null) {
      await prefs.setString('userFecha', fecha);
    }
    if (pais != null) {
      await prefs.setString('userPais', pais);
    }
    if (genero != null) {
      await prefs.setString('userGenero', genero);
    }
    if (nombre != null) {
      await prefs.setString('userNombre', nombre);
    }
  }
}
