import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_service.dart';

class PostService {

  static String baseUrl = "http://10.0.2.2:8000/api";

  // 📥 OBTENER POSTS
  static Future<List> obtenerPosts() async {
    final response = await http.get(
      Uri.parse("$baseUrl/posts/")
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }

  // ➕ CREAR POST
  static Future<void> crearPost(String contenido) async {
    await http.post(
      Uri.parse("$baseUrl/post/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "usuario_id": UserService.userId,
        "contenido": contenido,
      }),
    );
  }
}