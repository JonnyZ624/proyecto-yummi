import 'package:flutter/material.dart';
import '../services/plato_service.dart';
import 'plato_detalle_screen.dart';

class EmpresaPlatosScreen extends StatefulWidget {
  final String empresa;

  const EmpresaPlatosScreen({super.key, required this.empresa});

  @override
  State<EmpresaPlatosScreen> createState() => _EmpresaPlatosScreenState();
}

class _EmpresaPlatosScreenState extends State<EmpresaPlatosScreen> {

  List platos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  void cargar() async {
    final data = await PlatoService.obtenerPorEmpresa(widget.empresa);

    setState(() {
      platos = data;
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),

                  Text(
                    widget.empresa,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Icon(Icons.search, color: Colors.green),
                ],
              ),
            ),

            // 🟡 BANNER (IMAGEN DESDE ASSETS)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1),
                child: Image.asset(
                  "assets/images/comer_bien_amarillo.png", // 🔥 CAMBIA EL NOMBRE SI QUIERES
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 🔥 CONTENIDO
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : platos.isEmpty
                      ? const Center(child: Text("No hay platos"))
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: platos.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) {

                            final p = platos[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PlatoDetalleScreen(plato: p),
                                  ),
                                );
                              },
                              child: platoCard(
                                p["nombre"],
                                p["precio"],
                                p["imagen"],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧱 CARD ESTILO MODERNO
  Widget platoCard(String nombre, String precio, String imagen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🖼 IMAGEN + ⭐
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Image.network(
                  imagen,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // ⭐ FAVORITO (solo visual)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 💰 PRECIO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "\$ $precio",
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(height: 2),

          // 🍽 NOMBRE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              nombre,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 6),

          // 📍 UBICACIÓN
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