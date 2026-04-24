import 'package:flutter/material.dart';
import 'categoria_screen.dart';
import 'carrito_screen.dart';
import 'empresa_platos_screen.dart';
import '../services/empresa_service.dart';

class HomeScreen extends StatefulWidget {
  final String nombre;
  final Function(String) onSelectCategoria;

  const HomeScreen({
    super.key,
    required this.nombre,
    required this.onSelectCategoria,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List empresas = [];
  bool loadingEmpresas = true;

  @override
  void initState() {
    super.initState();
    cargarEmpresas();
  }

  void cargarEmpresas() async {
    final data = await EmpresaService.obtenerEmpresas();

    setState(() {
      empresas = data;
      loadingEmpresas = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.circle, color: Colors.green, size: 12),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Hola,", style: TextStyle(color: Colors.black, fontSize: 14)),
                Text(
                  widget.nombre,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CarritoScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    "1",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              )
            ],
          ),

          // 🔥 LOGO (TU IMAGEN)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Image.asset(
              "assets/images/iconos_yumi.png", // 🔥 CAMBIA POR TU IMAGEN
              width: 35,
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔍 BUSCADOR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Buscar comida",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(Icons.search, color: Colors.green)
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 🔘 FILTROS
            Row(
              children: [
                filtro("Ubicación"),
                filtro("Precio"),
                filtro("Favoritos"),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Explora por categoría",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            // 🔥 CATEGORÍAS (MISMA FUNCIONALIDAD)
            GridView.builder(
              itemCount: categorias.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemBuilder: (context, index) {
                final cat = categorias[index];
                return categoria(context, cat);
              },
            ),

            const SizedBox(height: 20),

            // 🟢 BANNER (TU IMAGEN)
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                image: const DecorationImage(
                  image: AssetImage("assets/images/comer_bien_verde.png"), // 🔥 CAMBIA
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Emprendimientos destacados",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // 🔥 EMPRESAS EN GRID (NO HORIZONTAL)
            loadingEmpresas
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    itemCount: empresas.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      return empresa(context, empresas[index]);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  // 🔘 FILTRO UI
  Widget filtro(String texto) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(texto),
          const Icon(Icons.arrow_drop_down, size: 16)
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> categorias = [
    {"icono": "🍳", "titulo": "Desayuno", "color": Colors.green},
    {"icono": "🍛", "titulo": "Almuerzo", "color": Colors.purple},
    {"icono": "🍲", "titulo": "Cena", "color": Colors.orange},
    {"icono": "🍎", "titulo": "Frutas", "color": Colors.deepPurple},
    {"icono": "🥦", "titulo": "Vegetales", "color": Colors.amber},
    {"icono": "🍗", "titulo": "Proteínas", "color": Colors.green},
  ];

  // 🔥 NO TOCA FUNCIONALIDAD
  Widget categoria(BuildContext context, Map cat) {
    return GestureDetector(
      onTap: () {
        widget.onSelectCategoria(cat["titulo"]);
      },
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: cat["color"],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                cat["icono"],
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(cat["titulo"]),
        ],
      ),
    );
  }

  // 🔥 EMPRESA CON DISEÑO DE TARJETA
  Widget empresa(BuildContext context, dynamic empresa) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EmpresaPlatosScreen(
              empresa: empresa["nombre"],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
            )
          ],
        ),
        child: Column(
          children: [

            // 🖼 IMAGEN
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                empresa["imagen"],
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 5),

            // 🟣 INFO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    empresa["nombre"],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Guayaquil, Ec",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const Text(
                    "Ver más >",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}