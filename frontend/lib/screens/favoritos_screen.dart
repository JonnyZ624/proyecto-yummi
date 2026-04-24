import 'package:flutter/material.dart';
import '../services/favorito_service.dart';
import 'plato_detalle_screen.dart';

class FavoritosScreen extends StatefulWidget {

  final Function() onBack; // 🔥 NUEVO

  const FavoritosScreen({
    super.key,
    required this.onBack,
  });

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {

  List favoritos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  void cargar() async {
    final data = await FavoritoService.obtenerFavoritos();

    setState(() {
      favoritos = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: Column(
          children: [

            // 🔝 HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      // 🔙 AHORA SÍ FUNCIONA
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: widget.onBack,
                      ),

                      const Text(
                        "Favoritos ❤️",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Icon(Icons.search, color: Colors.green),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      filtroChip("Ubicación"),
                      filtroChip("Precio"),
                      filtroChip("Favoritos"),
                    ],
                  ),
                ],
              ),
            ),

            // 🔥 GRID
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : favoritos.isEmpty
                      ? const Center(child: Text("No tienes favoritos"))
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: favoritos.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.68,
                          ),
                          itemBuilder: (context, index) {

                            final f = favoritos[index];

                            return GestureDetector(
                              onTap: () async {

                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => const Center(child: CircularProgressIndicator()),
                                );

                                try {
                                  final platoCompleto =
                                      await FavoritoService.obtenerPlato(f["id"]);

                                  Navigator.pop(context);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PlatoDetalleScreen(
                                        plato: platoCompleto,
                                        onBack: () => Navigator.pop(context),
                                      ),
                                    ),
                                  );

                                } catch (e) {
                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Error cargando plato")),
                                  );
                                }
                              },

                              child: platoCard(f),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filtroChip(String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(texto, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 16),
        ],
      ),
    );
  }

  Widget platoCard(dynamic f) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Stack(
            children: [

              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Image.network(
                  f["imagen"],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                right: 8,
                top: 8,
                child: GestureDetector(
                  onTap: () async {
                    await FavoritoService.eliminar(f["id"]);
                    cargar();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "\$ ${f["precio"]}",
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(height: 2),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              f["nombre"],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 6),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  "Guayaquil, EC",
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}