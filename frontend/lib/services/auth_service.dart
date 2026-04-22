import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_service.dart';

class AuthService {

  static const String baseUrl = "http://10.0.2.2:8000/api";

  // =========================
  // 🔥 REGISTER
  // =========================
  static Future<bool> register(
    String nombre,
    String email,
    String password,
    String username,
    String telefono,
    String foto,
  ) async {

    final url = Uri.parse("$baseUrl/register/");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nombre": nombre,
        "email": email,
        "password": password,
        "username": username,
        "telefono": telefono,
        "foto": foto,
      }),
    );

    print("REGISTER: ${response.body}");

    return response.statusCode == 200;
  }

  // =========================
  // 🔥 LOGIN
  // =========================
  static Future<bool> login(String email, String password) async {

    final response = await http.post(
      Uri.parse("$baseUrl/login/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    print("LOGIN: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // 🔥 GUARDAR SESIÓN
      await UserService.guardarSesion(
        data["id"],
        data["nombre"],
      );

      return true;
    }

    return false;
  }
}