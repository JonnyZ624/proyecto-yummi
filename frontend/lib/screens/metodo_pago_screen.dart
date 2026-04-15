import 'package:flutter/material.dart';
import 'tarjeta_screen.dart';
import 'factura_screen.dart';
import 'package:frontend/services/carrito_service.dart';

class MetodoPagoScreen extends StatefulWidget {
  const MetodoPagoScreen({super.key});

  @override
  State<MetodoPagoScreen> createState() => _MetodoPagoScreenState();
}

class _MetodoPagoScreenState extends State<MetodoPagoScreen> {

  String metodoSeleccionado = "Efectivo";

  @override
  Widget build(BuildContext context) {

    double total = CarritoService.total(); // 🔥 TOTAL REAL

    return Scaffold(
      appBar: AppBar(
        title: const Text("Método de pago"),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const Text(
              "Selecciona tu método de pago",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            radioMetodo("Efectivo"),
            radioMetodo("Tarjeta crédito"),
            radioMetodo("Tarjeta débito"),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  if (CarritoService.carrito.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Carrito vacío ❌")),
                    );
                    return;
                  }

                  // 🔥 FLUJO
                  if (metodoSeleccionado == "Efectivo") {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FacturaScreen(
                          metodo: metodoSeleccionado,
                          total: total,
                        ),
                      ),
                    );

                  } else {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TarjetaScreen(
                          metodo: metodoSeleccionado,
                          total: total,
                        ),
                      ),
                    );

                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Continuar"),
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget radioMetodo(String metodo) {
    return RadioListTile(
      title: Text(metodo),
      value: metodo,
      groupValue: metodoSeleccionado,
      onChanged: (value) {
        setState(() {
          metodoSeleccionado = value!;
        });
      },
    );
  }
}