import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterStep2 extends StatefulWidget {

  final String nombre;
  final String email;
  final String password;

  const RegisterStep2({
    super.key,
    required this.nombre,
    required this.email,
    required this.password,
  });

  @override
  State<RegisterStep2> createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {

  final usernameController = TextEditingController();
  final telefonoController = TextEditingController();
  final fotoController = TextEditingController();

  void registrar() async {

    if (usernameController.text.isEmpty ||
        telefonoController.text.isEmpty ||
        fotoController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    bool ok = await AuthService.register(
      widget.nombre,
      widget.email,
      widget.password,
      usernameController.text,
      telefonoController.text,
      fotoController.text,
    );

    if (ok) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cuenta creada correctamente")),
      );

      // 🔥 REGRESAR AL LOGIN
      Navigator.popUntil(context, (route) => route.isFirst);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al registrar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Completar Perfil"),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: telefonoController,
              decoration: const InputDecoration(labelText: "Teléfono"),
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 10),

            TextField(
              controller: fotoController,
              decoration: const InputDecoration(labelText: "URL de foto"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: registrar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text("Crear Cuenta"),
            )

          ],
        ),
      ),
    );
  }
}