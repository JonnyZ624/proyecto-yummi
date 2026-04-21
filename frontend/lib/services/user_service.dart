import 'package:shared_preferences/shared_preferences.dart';

class UserService {

  static int? userId;
  static String? nombre;

  // 🔥 GUARDAR SESIÓN
  static Future<void> guardarSesion(int id, String nombreUser) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("userId", id);
    await prefs.setString("nombre", nombreUser);

    userId = id;
    nombre = nombreUser;
  }

  // 🔥 CARGAR SESIÓN
  static Future<bool> cargarSesion() async {
    final prefs = await SharedPreferences.getInstance();

    userId = prefs.getInt("userId");
    nombre = prefs.getString("nombre");

    return userId != null;
  }

  // 🔥 CERRAR SESIÓN
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    userId = null;
    nombre = null;
  }
}