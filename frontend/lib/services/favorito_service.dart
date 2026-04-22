import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_service.dart';

class FavoritoService {

  static String baseUrl = "http://10.0.2.2:8000/api";

  // ❤️ OBTENER FAVORITOS
  static Future<List> obtenerFavoritos() async {
    final response = await http.get(
      Uri.parse("$baseUrl/favorito/${UserService.userId}/")
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }

  // ➕ AGREGAR
  static Future<void> agregar(int platoId) async {
    await http.post(
      Uri.parse("$baseUrl/favorito/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "usuario_id": UserService.userId,
        "plato_id": platoId,
      }),
    );
  }

  // ❌ ELIMINAR
  static Future<void> eliminar(int platoId) async {
    await http.delete(
      Uri.parse("$baseUrl/favorito/eliminar/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "usuario_id": UserService.userId,
        "plato_id": platoId,
      }),
    );
  }
  
   
  static Future<Map<String, dynamic>> obtenerPlato(int id) async {
  final res = await http.get(
    Uri.parse("http://10.0.2.2:8000/api/plato/$id/")
  );

  return jsonDecode(res.body);
}

  static Future<bool> esFavorito(int platoId) async {
  final res = await http.get(
    Uri.parse("http://10.0.2.2:8000/api/favorito/check/${UserService.userId}/$platoId/")
  );

  final data = jsonDecode(res.body);
  return data["favorito"];
}


  static Future<bool> existe(int platoId) async {
  final favoritos = await obtenerFavoritos();
  return favoritos.any((f) => f["id"] == platoId);
}

}