import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_step1.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // 🟢 COLOR DE FONDO (IGUAL QUE EL OTRO SCREEN)
          Container(
            color: const Color(0xff5E8F00),
          ),

          // 🥕 IMAGEN ENCIMA DEL COLOR (MISMO ESTILO)
          Positioned.fill(
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                "assets/images/aplicacion_saludable _joss patron_39.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 📱 CONTENIDO
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Spacer(),

                  // 🔥 LOGO
                  Image.asset(
                    "assets/images/iconos_yumi.png",
                    height: 120,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "¡Qué gusto verte!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Crea tu cuenta y empieza a elegir mejor",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 40),

                  // 🔵 BOTÓN LOGIN
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6C2BD9),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Iniciar sesión",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🟢 BOTÓN REGISTER
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterStep1(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        "Crear una cuenta",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}