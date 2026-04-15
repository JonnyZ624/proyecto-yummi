import 'package:flutter/material.dart';
import 'package:frontend/services/pedido_service.dart';
import 'package:frontend/services/carrito_service.dart';
import 'pago_exitoso_screen.dart';

class FacturaScreen extends StatefulWidget {
  final String metodo;
  final double total;

  const FacturaScreen({
    super.key,
    required this.metodo,
    required this.total,
  });

  @override
  State<FacturaScreen> createState() => _FacturaScreenState();
}

class _FacturaScreenState extends State<FacturaScreen> {

  final usuario = TextEditingController();
  final ci = TextEditingController();
  final ubicacion = TextEditingController();
  final telefono = TextEditingController();

  @override
  void dispose() {
    usuario.dispose();
    ci.dispose();
    ubicacion.dispose();
    telefono.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true, // 🔥 evita errores con teclado

      appBar: AppBar(
        title: const Text("Datos de factura"),
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 💳 RESUMEN
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      "Método: ${widget.metodo}",
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "Total: \$${widget.total.toStringAsFixed(2)}", // ✅ CORREGIDO
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 👤 NOMBRE
            TextField(
              controller: usuario,
              decoration: const InputDecoration(
                labelText: "Nombre",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // 🆔 CI
            TextField(
              controller: ci,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "CI",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // 📍 UBICACIÓN
            TextField(
              controller: ubicacion,
              decoration: const InputDecoration(
                labelText: "Ubicación",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // 📞 TELÉFONO
            TextField(
              controller: telefono,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Teléfono",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ BOTÓN CONFIRMAR
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {

                  // 🔥 VALIDACIÓN
                  if (usuario.text.isEmpty ||
                      ci.text.isEmpty ||
                      ubicacion.text.isEmpty ||
                      telefono.text.isEmpty) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Completa todos los datos ❌"),
                      ),
                    );
                    return;
                  }

                  // 🚀 ENVIAR PEDIDO
                  bool ok = await PedidoService.enviarPedido(
                    widget.metodo,
                    usuario.text,
                    ci.text,
                    ubicacion.text,
                    telefono.text,
                  );

                  if (ok) {

                    // 🧹 LIMPIAR
                    CarritoService.limpiar();

                    // ✅ IR A PAGO EXITOSO
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PagoExitosoScreen(),
                      ),
                    );

                  } else {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Error al confirmar pedido ❌"),
                      ),
                    );

                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Confirmar"),
              ),
            )

          ],
        ),
      ),
    );
  }
}