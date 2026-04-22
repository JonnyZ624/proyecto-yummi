import 'package:flutter/material.dart';
import '../services/post_service.dart';

class ComunidadScreen extends StatefulWidget {
  const ComunidadScreen({super.key});

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
    cargar();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Comunidad 🌎"),
        backgroundColor: Colors.green,
      ),

      body: Column(
        children: [

          // ✍️ CREAR POST
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: ctrl,
                    decoration: const InputDecoration(
                      hintText: "¿Qué estás pensando?",
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: publicar,
                )

              ],
            ),
          ),

          // 📜 LISTA
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {

                      final p = posts[index];

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                p["usuario"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(p["contenido"]),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
          )

        ],
      ),
    );
  }
}