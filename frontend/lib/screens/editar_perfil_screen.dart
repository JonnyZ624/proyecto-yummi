import 'package:flutter/material.dart';
import '../services/user_service.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {

  final nombreCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();

  Map<String, dynamic>? perfil;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  void cargar() async {
    final data = await UserService.obtenerPerfil();

    if (data != null) {
      perfil = data;

      nombreCtrl.text = data["nombre"] ?? "";
      emailCtrl.text = data["email"] ?? "";
      usernameCtrl.text = data["username"] ?? "";
      telefonoCtrl.text = data["telefono"] ?? "";
    }

    setState(() {
      loading = false;
    });
  }

  void guardar() async {

    if (nombreCtrl.text.isEmpty || usernameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nombre y username son obligatorios")),
      );
      return;
    }

    bool ok = await UserService.editarPerfil(
      nombre: nombreCtrl.text,
      username: usernameCtrl.text,
      telefono: telefonoCtrl.text,
    );

    if (ok) {
      Navigator.pop(context); // vuelve al perfil
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al actualizar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        title: const Text("Editar Perfil"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: guardar,
          )
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : perfil == null
              ? const Center(child: Text("Error al cargar perfil"))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [

                      // 🔥 FOTO DINÁMICA
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          perfil!["foto"] != null &&
                                  perfil!["foto"].toString().isNotEmpty
                              ? perfil!["foto"]
                              : "https://i.imgur.com/BoN9kdC.png",
                        ),
                      ),

                      const SizedBox(height: 20),

                      campo("Nombre", nombreCtrl),
                      campo("Correo Electrónico", emailCtrl, enabled: false),
                      campo("Nombre Usuario", usernameCtrl),
                      campo("Número de teléfono", telefonoCtrl),

                    ],
                  ),
                ),
    );
  }

  Widget campo(String label, TextEditingController ctrl, {bool enabled = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: ctrl,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}