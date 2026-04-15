import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'plato_detalle_screen.dart';

class CategoriaScreen extends StatefulWidget {
  final String categoria;

  const CategoriaScreen({super.key, required this.categoria});

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

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        platos = jsonDecode(response.body);
        loading = false;
      });
    } else {
      print("Error cargando platos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoria),
        backgroundColor: Colors.green,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : platos.isEmpty
              ? const Center(child: Text("No hay platos"))
              : GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: platos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final plato = platos[index];

                    // 🔥 AQUÍ ESTÁ EL CAMBIO IMPORTANTE
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlatoDetalleScreen(plato: plato),
                          ),
                        );
                      },
                      child: platoCard(
                        plato["nombre"],
                        plato["precio"],
                        plato["imagen"],
                      ),
                    );
                  },
                ),
    );
  }

  Widget platoCard(String nombre, String precio, String imagen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              imagen,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "\$ $precio",
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

        ],
      ),
    );
  }
}