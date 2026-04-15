import 'package:flutter/material.dart';
import 'factura_screen.dart';
import 'gracias_screen.dart';

class PagoExitosoScreen extends StatelessWidget {
  const PagoExitosoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),

            const Text(
              "Pago exitoso 🎉",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GraciasScreen(),
                  ),
                );
              },
              child: const Text("Siguiente"),
            )

          ],
        ),
      ),
    );
  }
}