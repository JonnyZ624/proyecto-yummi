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

    double total = CarritoService.total();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Método de pago",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black), // 🔥 botón atrás negro
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const SizedBox(height: 10),

            metodoCard("Tarjeta crédito"),
            metodoCard("Tarjeta débito"),
            metodoCard("Efectivo"),

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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Continuar",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget metodoCard(String metodo) {
    bool seleccionado = metodoSeleccionado == metodo;

    return GestureDetector(
      onTap: () {
        setState(() {
          metodoSeleccionado = metodo;
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: seleccionado ? Colors.green : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            metodo,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}