import 'package:flutter/material.dart';
import 'categoria_screen.dart';
import 'carrito_screen.dart';
import 'empresa_platos_screen.dart';
import '../services/empresa_service.dart'; // 🔥 NUEVO

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
      backgroundColor: Colors.green[50],

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Yumi Eats 🍃"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CarritoScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Hola ${widget.nombre} 👋",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "¿Qué quieres comer hoy?",
                style: TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 20),

              GridView.builder(
                itemCount: categorias.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) {
                  final cat = categorias[index];
                  return categoria(context, cat["icono"]!, cat["titulo"]!);
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "Empresas destacadas",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              loadingEmpresas
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: empresas.length,
                        itemBuilder: (context, index) {
                          return empresa(context, empresas[index]);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  final List<Map<String, String>> categorias = [
    {"icono": "🍳", "titulo": "Desayuno"},
    {"icono": "🍛", "titulo": "Almuerzo"},
    {"icono": "🍲", "titulo": "Cena"},
    {"icono": "🍎", "titulo": "Frutas"},
    {"icono": "🥦", "titulo": "Vegetales"},
    {"icono": "🍗", "titulo": "Proteínas"},
  ];

  Widget categoria(BuildContext context, String icono, String titulo) {
    return GestureDetector(
      onTap: () {
        widget.onSelectCategoria(titulo);
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icono, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 10),
              Text(titulo, style: const TextStyle(fontSize: 16))
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 EMPRESA REAL DESDE DJANGO
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
        width: 120,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          children: [

            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(empresa["imagen"]),
            ),

            const SizedBox(height: 5),

            Text(
              empresa["nombre"],
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}