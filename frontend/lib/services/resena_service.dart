import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_service.dart';

class ResenaService {

  static const baseUrl = "http://10.0.2.2:8000/api";

  // 📥 OBTENER RESEÑAS
  static Future<List> obtener(int platoId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/resenas/$platoId/"),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    return [];
  }

  // 📤 CREAR RESEÑA (🔥 AHORA RETORNA BOOL)
  static Future<bool> crear(
    int platoId,
    String comentario,
    int calificacion,
  ) async {

    final res = await http.post(
      Uri.parse("$baseUrl/resena/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "usuario_id": UserService.userId,
        "plato_id": platoId,
        "comentario": comentario,
        "calificacion": calificacion
      }),
    );

    // 🔥 RESPUESTA
    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}