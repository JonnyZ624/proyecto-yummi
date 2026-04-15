import 'dart:convert';
import 'package:http/http.dart' as http;
import 'carrito_service.dart';
import 'user_service.dart';

class PedidoService {

  static Future<bool> enviarPedido(
    String metodoPago,
    String nombre,
    String ci,
    String ubicacion,
    String telefono,
  ) async {

    final url = Uri.parse("http://10.0.2.2:8000/api/pedido/");

    // 🚫 evitar enviar vacío
    if (CarritoService.carrito.isEmpty) {
      print("Carrito vacío ❌");
      return false;
    }

    // 🧾 productos del carrito (con cantidad)
    List productos = CarritoService.carrito.map((p) {
      return {
        "id": p["id"],
        "cantidad": p["cantidad"] ?? 1
      };
    }).toList();

    // 🔥 EXTRAS
    List extras = [];

    for (var p in CarritoService.carrito) {
      if (p["extras"] != null) {
        extras.addAll(p["extras"]);
      }
    }

    // 💰 TOTAL CORRECTO
    double total = 0;

    for (var p in CarritoService.carrito) {
      if (p["precio_total"] != null) {
        // 🔥 ya incluye cantidad
        total += double.parse(p["precio_total"].toString());
      } else {
        // 🔥 calcular manual
        double precio = double.parse(p["precio"].toString());
        int cantidad = p["cantidad"] ?? 1;
        total += precio * cantidad;
      }
    }

    final body = {
      "usuario_id": UserService.userId,
      "total": total,
      "metodo_pago": metodoPago,
      "productos": productos,
      "extras": extras,

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
      print("ERROR DE CONEXIÓN: $e");
      return false;
    }
  }
}