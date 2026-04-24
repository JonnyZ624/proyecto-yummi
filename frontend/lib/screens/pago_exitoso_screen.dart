import 'package:flutter/material.dart';
import 'factura_screen.dart';
import 'gracias_screen.dart';

class PagoExitosoScreen extends StatelessWidget {
  const PagoExitosoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // 🟢 COLOR DE FONDO
          Container(
            color: const Color(0xff5E8F00), // verde
          ),

          // 🥕 IMAGEN DE VERDURAS (encima del color)
          Positioned.fill(
            child: Opacity(
              opacity: 0.9, // ajusta si quieres más tenue
              child: Image.asset(
                "assets/images/aplicacion_saludable _joss patron_39.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ✅ CONTENIDO
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // CÍRCULO BLANCO CON CHECK
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xff5E8F00),
                    size: 60,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "Pago exitoso",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 40),

                // 🔥 BOTÓN MORADO
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GraciasScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff6C2BD9),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
  "Siguiente",
  style: TextStyle(color: Colors.white),
),
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