import 'package:flutter/material.dart';
import 'package:frontend/screens/home_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/services/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                "Yumi Eats 🍃",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Correo",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {

                        if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Completa todos los campos"),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          loading = true;
                        });

                        try {
                          final url = Uri.parse("http://10.0.2.2:8000/api/login/");

                          final response = await http.post(
                            url,
                            headers: {"Content-Type": "application/json"},
                            body: jsonEncode({
                              "email": emailController.text,
                              "password": passwordController.text,
                            }),
                          );

                          print("STATUS: ${response.statusCode}");
                          print("BODY: ${response.body}");

                          final data = jsonDecode(response.body);

                          if (response.statusCode == 200) {

                            // 🔥 VALIDACIÓN EXTRA (MUY IMPORTANTE)
                            String nombre = data['nombre'];
int userId = data['id'];

                            // 🔥 GUARDAR USUARIO
                            UserService.userId = userId;
                            UserService.nombre = nombre;

                            print("Usuario guardado: $userId - $nombre");

                            // 🚀 IR A HOME (REEMPLAZA PANTALLA)
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(nombre: nombre),
                              ),
                            );

                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  data['error'] ?? "Error al iniciar sesión"
                                ),
                              ),
                            );
                          }

                        } catch (e) {
                          print("ERROR: $e");

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Error de conexión ❌"),
                            ),
                          );
                        }

                        setState(() {
                          loading = false;
                        });
                      },
                      child: const Text("Iniciar sesión"),
                    ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () {},
                child: const Text("Crear cuenta"),
              )

            ],
          ),
        ),
      ),
    );
  }
}