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
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        title: const Text(
          "Datos de factura",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xfff5f5f5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // RESUMEN
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Método: ${widget.metodo}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Total: \$${widget.total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // CAMPOS
            _input(usuario, "Usuario"),
            _input(ci, "C.I / RUC", isNumber: true),
            _input(ubicacion, "Ubicación"),
            _input(telefono, "Teléfono", isPhone: true),

            const SizedBox(height: 40),

            // BOTÓN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {

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

                  bool ok = await PedidoService.enviarPedido(
                    widget.metodo,
                    usuario.text,
                    ci.text,
                    ubicacion.text,
                    telefono.text,
                  );

                  if (ok) {
                    CarritoService.limpiar();

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
                  backgroundColor: const Color(0xff6C2BD9),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Pedir",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(TextEditingController controller, String label,
      {bool isNumber = false, bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        keyboardType: isNumber
            ? TextInputType.number
            : isPhone
                ? TextInputType.phone
                : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}