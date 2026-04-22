import 'dart:convert';
import 'package:http/http.dart' as http;

class PlatoService {

  static String baseUrl = "http://10.0.2.2:8000/api";

  static Future<List> obtenerPorEmpresa(String empresa) async {

    final response = await http.get(
      Uri.parse("$baseUrl/platos/")
    );

    if (response.statusCode == 200) {

      List data = jsonDecode(response.body);

      // 🔥 FILTRAR POR EMPRESA
      return data.where((p) =>
        (p["empresa"] ?? "").toString().toLowerCase() ==
        empresa.toLowerCase()
      ).toList();

    }

    return [];
  }
}