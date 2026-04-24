import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoriaScreen extends StatefulWidget {
  final String categoria;

  final Function(Map) onSelectPlato;
  final Function() onBack;

  const CategoriaScreen({
    super.key,
    required this.categoria,
    required this.onSelectPlato,
    required this.onBack,
  });

  @override
  State<CategoriaScreen> createState() => _CategoriaScreenState();
}

class _CategoriaScreenState extends State<CategoriaScreen> {

  List platos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    obtenerPlatos();
  }

  Future<void> obtenerPlatos() async {
    final url = Uri.parse(
      "http://10.0.2.2:8000/api/platos/?categoria=${widget.categoria}"
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        platos = jsonDecode(response.body);
        loading = false;
      });
    }
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

                  // 🔙 + TÍTULO + 🔍
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: widget.onBack,
                      ),

                      Text(
                        widget.categoria,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Icon(Icons.search, color: Colors.green),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 🔘 FILTROS
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
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: platos.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.68,
                      ),
                      itemBuilder: (context, index) {
                        final plato = platos[index];

                        return GestureDetector(
                          onTap: () {
                            widget.onSelectPlato(plato);
                          },
                          child: platoCard(
                            plato["nombre"],
                            plato["precio"],
                            plato["imagen"],
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

  // 🔘 CHIP FILTRO
  Widget filtroChip(String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            texto,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 16),
        ],
      ),
    );
  }

  // 🧱 CARD
  Widget platoCard(String nombre, String precio, String imagen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🖼 IMAGEN
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.network(
              imagen,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
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
                Icon(
                  Icons.location_on,
                  size: 14,
                  color: Colors.grey,
                ),
                SizedBox(width: 4),
                Text(
                  "Guayaquil, EC",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}