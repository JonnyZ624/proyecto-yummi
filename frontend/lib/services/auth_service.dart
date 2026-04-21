import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {

  static const String baseUrl = "http://10.0.2.2:8000/api";

  static Future<bool> register(
    String nombre,
    String email,
    String password,
    String username,
    String telefono,
    String foto,
  ) async {

    final url = Uri.parse("$baseUrl/register/");

    final body = {
      "nombre": nombre,
      "email": email,
      "password": password,
      "username": username,
      "telefono": telefono,
      "foto": foto
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("REGISTER: ${response.body}");

      return response.statusCode == 200;

    } catch (e) {
      print("ERROR REGISTER: $e");
      return false;
    }
  }
}