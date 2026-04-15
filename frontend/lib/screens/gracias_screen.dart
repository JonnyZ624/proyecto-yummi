import 'package:flutter/material.dart';
import 'seguimiento_screen.dart';

class GraciasScreen extends StatelessWidget {
  const GraciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "Gracias 🙌",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const Text("Tu pedido llegará pronto 🚚"),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SeguimientoScreen(),
                  ),
                );
              },
              child: const Text("Ver mi pedido"),
            )

          ],
        ),
      ),
    );
  }
}