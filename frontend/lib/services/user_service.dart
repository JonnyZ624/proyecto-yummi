import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {

  static int? userId;
  static String? nombre;

  static String baseUrl = "http://10.0.2.2:8000/api";

  // =========================
  // 🔥 GUARDAR SESIÓN
  // =========================
  static Future<void> guardarSesion(int id, String nombreUser) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt("userId", id);
    await prefs.setString("nombre", nombreUser);

    userId = id;
    nombre = nombreUser;

    print("✅ SESIÓN GUARDADA: $userId");
  }

  // =========================
  // 🔥 CARGAR SESIÓN
  // =========================
  static Future<bool> cargarSesion() async {
    final prefs = await SharedPreferences.getInstance();

    userId = prefs.getInt("userId");
    nombre = prefs.getString("nombre");

    print("🔁 SESIÓN CARGADA: $userId");

    return userId != null;
  }

  // =========================
  // 🔥 CERRAR SESIÓN
  // =========================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    userId = null;
    nombre = null;

    print("🚪 SESIÓN CERRADA");
  }

  // =========================
  // 🔥 OBTENER PERFIL
  // =========================
  static Future<Map<String, dynamic>?> obtenerPerfil() async {

    // 🔥 ASEGURAR SESIÓN
    if (userId == null) {
      bool existe = await cargarSesion();
      if (!existe) {
        print("❌ NO HAY SESIÓN");
        return null;
      }
    }

    print("📡 CONSULTANDO PERFIL ID: $userId");

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/perfil/$userId/")
      );

      print("STATUS PERFIL: ${response.statusCode}");
      print("BODY PERFIL: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("❌ ERROR BACKEND PERFIL");
      }

    } catch (e) {
      print("❌ ERROR REQUEST PERFIL: $e");
    }

    return null;
  }

  // =========================
  // 🔥 EDITAR PERFIL
  // =========================
  static Future<bool> editarPerfil({
    required String nombre,
    required String username,
    required String telefono,
  }) async {

    if (userId == null) {
      bool existe = await cargarSesion();
      if (!existe) {
        print("❌ NO HAY SESIÓN PARA EDITAR");
        return false;
      }
    }

    print("✏️ EDITANDO PERFIL ID: $userId");

    try {
      final response = await http.put(
        Uri.parse("$baseUrl/perfil/editar/$userId/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombre,
          "username": username,
          "telefono": telefono,
        }),
      );

      print("STATUS EDITAR: ${response.statusCode}");
      print("BODY EDITAR: ${response.body}");

      if (response.statusCode == 200) {
        UserService.nombre = nombre;
        return true;
      } else {
        print("❌ ERROR BACKEND EDITAR");
      }

    } catch (e) {
      print("❌ ERROR REQUEST EDITAR: $e");
    }

    return false;
  }
}