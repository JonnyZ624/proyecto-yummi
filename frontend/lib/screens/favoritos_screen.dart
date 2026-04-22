import 'package:flutter/material.dart';
import '../services/favorito_service.dart';
import 'plato_detalle_screen.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

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
      appBar: AppBar(
        title: const Text("Favoritos ❤️"),
        backgroundColor: Colors.green,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : favoritos.isEmpty
              ? const Center(child: Text("No tienes favoritos"))
              : ListView.builder(
                  itemCount: favoritos.length,
                  itemBuilder: (context, index) {

                    final f = favoritos[index];

                    return ListTile(
                      leading: Image.network(f["imagen"], width: 50, fit: BoxFit.cover),
                      title: Text(f["nombre"]),
                      subtitle: Text("\$ ${f["precio"]}"),

                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FavoritoService.eliminar(f["id"]);
                          cargar();
                        },
                      ),

                      onTap: () async {

  // 🔥 LOADING PRO
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final platoCompleto =
        await FavoritoService.obtenerPlato(f["id"]);

    Navigator.pop(context); // cerrar loading

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
                    );
                  },
                ),
    );
  }
}