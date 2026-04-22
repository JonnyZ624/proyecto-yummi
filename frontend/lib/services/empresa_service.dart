import 'dart:convert';
import 'package:http/http.dart' as http;

class EmpresaService {

  static String baseUrl = "http://10.0.2.2:8000/api";

  static Future<List> obtenerEmpresas() async {
    final response = await http.get(
      Uri.parse("$baseUrl/empresas/")
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  }
}