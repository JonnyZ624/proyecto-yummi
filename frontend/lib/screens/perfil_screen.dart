import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'login_screen.dart';
import 'editar_perfil_screen.dart';

class PerfilScreen extends StatefulWidget {
  final VoidCallback onBack;

  const PerfilScreen({
    super.key,
    required this.onBack,
  });

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
      backgroundColor: Colors.white, // 👈 fondo blanco como diseño

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
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

                    // 🟩 CARD PERFIL (más limpia)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5A8F1C), // verde más elegante
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [

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
                                const SizedBox(height: 4),
                                Text(
                                  perfil!["email"] ?? "",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EditarPerfilScreen(),
                                ),
                              );
                              cargarPerfil();
                            },
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // 📄 OPCIONES
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

  // 🔥 NUEVO ESTILO MINIMALISTA
  Widget opcion(String titulo, IconData icono, VoidCallback onTap) {
    return Column(
      children: [

        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [

                Icon(icono, color: Colors.grey),

                const SizedBox(width: 15),

                Expanded(
                  child: Text(
                    titulo,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),

                const Icon(Icons.arrow_forward_ios,
                    size: 14, color: Colors.grey),
              ],
            ),
          ),
        ),

        // línea divisoria suave
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(height: 1, color: Colors.grey),
        ),
      ],
    );
  }
}