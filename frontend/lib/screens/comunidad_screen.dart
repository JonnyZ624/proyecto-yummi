import 'package:flutter/material.dart';

class ComunidadScreen extends StatelessWidget {
  const ComunidadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comunidad"),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text("Aquí van los posts 💬"),
      ),
    );
  }
}