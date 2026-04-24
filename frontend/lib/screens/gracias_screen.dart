import 'package:flutter/material.dart';
import 'seguimiento_screen.dart';

class GraciasScreen extends StatelessWidget {
  const GraciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // 🟢 COLOR BASE
          Container(
            color: const Color(0xFF6A8F00),
          ),

          // 🥕 IMAGEN DE VERDURAS
          Positioned.fill(
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                'assets/images/aplicacion_saludable _joss patron_39.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // CONTENIDO ORIGINAL
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset(
                  'assets/images/iconos_yumi.png',
                  width: 80,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Gracias",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Tu pedido\nllegará pronto",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SeguimientoScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Ver mi pedido",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}