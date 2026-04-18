import 'dart:convert';
import 'package:http/http.dart' as http;
import 'carrito_service.dart';
import 'user_service.dart';

class PedidoService {

  // =========================
  // 🚀 ENVIAR PEDIDO
  // =========================
  static Future<bool> enviarPedido(
    String metodoPago,
    String nombre,
    String ci,
    String ubicacion,
    String telefono,
  ) async {

    final url = Uri.parse("http://10.0.2.2:8000/api/pedido/");

    if (CarritoService.carrito.isEmpty) {
      print("Carrito vacío ❌");
      return false;
    }

    // 🔥 PRODUCTOS CON EXTRAS
    List productos = CarritoService.carrito.map((p) {
      return {
        "id": p["id"],
        "cantidad": p["cantidad"] ?? 1,
        "extras": p["extras"] ?? []
      };
    }).toList();

    // 💰 TOTAL REAL
    double total = 0;

    for (var p in CarritoService.carrito) {
      double precioBase = double.parse(p["precio"].toString());

      double extrasTotal = 0;
      if (p["extras"] != null) {
        for (var e in p["extras"]) {
          extrasTotal += double.parse(e["precio"].toString()) *
              (e["cantidad"] ?? 1);
        }
      }

      int cantidad = p["cantidad"] ?? 1;

      total += (precioBase + extrasTotal) * cantidad;
    }

    final body = {
      "usuario_id": UserService.userId,
      "total": total,
      "metodo_pago": metodoPago,
      "productos": productos,

      // 🔥 FACTURA
      "nombre_cliente": nombre,
      "ci": ci,
      "ubicacion": ubicacion,
      "telefono": telefono,
    };

    print("ENVIANDO PEDIDO:");
    print(jsonEncode(body));

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      return response.statusCode == 200;

    } catch (e) {
      print("ERROR: $e");
      return false;
    }
  }


  // =========================
  // 📦 OBTENER PEDIDO ACTUAL
  // =========================
  static Future<Map<String, dynamic>?> obtenerPedidoActual() async {

    final url = Uri.parse(
        "http://10.0.2.2:8000/api/pedido/${UserService.userId}/");

    try {
      final response = await http.get(url);

      print("GET PEDIDO STATUS: ${response.statusCode}");
      print("GET PEDIDO BODY: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

    } catch (e) {
      print("ERROR AL OBTENER PEDIDO: $e");
    }

    return null;
  }
}