import 'package:flutter/material.dart';

class SeguimientoScreen extends StatelessWidget {
  const SeguimientoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seguimiento"),
        backgroundColor: Colors.green,
      ),

      body: Column(
        children: [

          const SizedBox(height: 20),

          Container(
            height: 300,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text("Mapa del pedido 📍"),
            ),
          ),

          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Repartidor: Juan Pérez", style: TextStyle(color: Colors.white)),
                SizedBox(height: 5),
                Text("Tiempo estimado: 20-25 min", style: TextStyle(color: Colors.white)),
              ],
            ),
          )

        ],
      ),
    );
  }
}