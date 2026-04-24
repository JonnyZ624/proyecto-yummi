import 'package:flutter/material.dart';
import '../services/post_service.dart';

class ComunidadScreen extends StatefulWidget {
  final Function() onBack;

  const ComunidadScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<ComunidadScreen> createState() => _ComunidadScreenState();
}

class _ComunidadScreenState extends State<ComunidadScreen> {
  List posts = [];
  bool loading = true;

  final ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargar();
  }

  void cargar() async {
    final data = await PostService.obtenerPosts();

    setState(() {
      posts = data;
      loading = false;
    });
  }

  void publicar() async {
    if (ctrl.text.isEmpty) return;

    await PostService.crearPost(ctrl.text);
    ctrl.clear();
    Navigator.pop(context);
    cargar();
  }

  void abrirCrearPost() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 15,
            right: 15,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Crear publicación",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: ctrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Comparte algo con la comunidad...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: publicar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text("Publicar"),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // 🔝 HEADER BLANCO
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),

        title: const Text(
          "Comunidad Yumi",
          style: TextStyle(color: Colors.black),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: abrirCrearPost,
          )
        ],
      ),

      body: Stack(
        children: [

          // 🌿 FONDO (NO se toca)
          Positioned.fill(
            child: Image.asset(
              "assets/images/aplicacion_saludable _joss patron_39.png",
              fit: BoxFit.cover,
            ),
          ),

          Column(
            children: [

              const SizedBox(height: 10),

              // 🟩 BANNER (igual)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/comer_bien_verde.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // 📄 LISTA (SIN fondo blanco global)
              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 20,
                        ),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final p = posts[index];

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white, // 👈 SOLO card blanca
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                // 👤 AVATAR (sin cambios)
                                CircleAvatar(
                                  backgroundColor: Colors.green,
                                  child: Text(
                                    p["usuario"][0],
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        p["contenido"],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          height: 1.4,
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      Text(
                                        p["usuario"],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Icon(Icons.favorite,
                                    color: Colors.grey, size: 20),
                              ],
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        ],
      ),
    );
  }
}