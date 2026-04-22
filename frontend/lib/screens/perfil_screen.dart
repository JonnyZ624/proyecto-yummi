import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'login_screen.dart';
import 'editar_perfil_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {

  Map<String, dynamic>? perfil;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarPerfil();
  }

  void cargarPerfil() async {
    final data = await UserService.obtenerPerfil();

    setState(() {
      perfil = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        title: const Text("Mi perfil"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : perfil == null
              ? const Center(child: Text("No se pudo cargar el perfil"))
              : Column(
                  children: [

                    const SizedBox(height: 20),

                    // 🔥 CARD VERDE
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [

                          // ✅ FOTO DINÁMICA
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              perfil!["foto"] != null &&
                                      perfil!["foto"].toString().isNotEmpty
                                  ? perfil!["foto"]
                                  : "https://i.imgur.com/BoN9kdC.png",
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  perfil!["nombre"] ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  perfil!["email"] ?? "",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),

                          // ✏️ EDITAR
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EditarPerfilScreen(),
                                ),
                              );

                              cargarPerfil(); // 🔥 refresca
                            },
                          )

                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔥 OPCIONES
                    opcion("Administrar cuenta", Icons.person, () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditarPerfilScreen(),
                        ),
                      );
                      cargarPerfil();
                    }),

                    opcion("Historial de pedidos", Icons.receipt, () {}),

                    opcion("Favoritos", Icons.favorite, () {}),

                    opcion("Plan Premium", Icons.workspace_premium, () {}),

                    opcion("Mis reseñas", Icons.star, () {}),

                    opcion("Desconectar", Icons.logout, () async {
                      await UserService.logout();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }),

                  ],
                ),
    );
  }

  Widget opcion(String titulo, IconData icono, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        tileColor: Colors.white,
        leading: Icon(icono, color: Colors.grey),
        title: Text(titulo),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}