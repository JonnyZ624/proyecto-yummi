import 'package:flutter/material.dart';
import 'package:frontend/services/carrito_service.dart';
import 'carrito_screen.dart';
import 'package:frontend/services/favorito_service.dart';
import 'package:frontend/services/resena_service.dart';

class PlatoDetalleScreen extends StatefulWidget {
  final Map<String, dynamic> plato;
  final VoidCallback? onBack;

  const PlatoDetalleScreen({
    super.key,
    required this.plato,
    this.onBack,
  });

  @override
  State<PlatoDetalleScreen> createState() => _PlatoDetalleScreenState();
}

class _PlatoDetalleScreenState extends State<PlatoDetalleScreen> {

  Map<int, int> cantidades = {};
  double precioTotal = 0;

  bool esFavorito = false;

  // ⭐ RESEÑAS
  List resenas = [];
  bool loadingResenas = true;

  final TextEditingController comentarioCtrl = TextEditingController();
  int rating = 5;

  @override
  void initState() {
    super.initState();
    precioTotal = double.parse(widget.plato["precio"].toString());

    verificarFavorito();
    cargarResenas();
  }

  void verificarFavorito() async {
    bool existe = await FavoritoService.existe(widget.plato["id"]);
    setState(() {
      esFavorito = existe;
    });
  }

  void cargarResenas() async {
    final data = await ResenaService.obtener(widget.plato["id"]);

    setState(() {
      resenas = data;
      loadingResenas = false;
    });
  }

  void recalcularTotal() {
    double base = double.parse(widget.plato["precio"].toString());
    double extrasTotal = 0;

    final ingredientes = widget.plato["ingredientes"] ?? [];

    for (var ing in ingredientes) {
      int id = ing["id"];
      double precio = double.parse(ing["precio"].toString());
      int cantidad = cantidades[id] ?? 0;
      extrasTotal += precio * cantidad;
    }

    setState(() {
      precioTotal = base + extrasTotal;
    });
  }

  @override
  Widget build(BuildContext context) {

    final plato = widget.plato;
    final ingredientes = plato["ingredientes"] ?? [];

    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(plato["nombre"]),
        backgroundColor: Colors.green,

        actions: [

          // ❤️ FAVORITO
          IconButton(
            icon: Icon(
              esFavorito ? Icons.favorite : Icons.favorite_border,
              color: esFavorito ? Colors.red : Colors.white,
            ),
            onPressed: () async {

              if (esFavorito) {
                await FavoritoService.eliminar(plato["id"]);
              } else {
                await FavoritoService.agregar(plato["id"]);
              }

              setState(() {
                esFavorito = !esFavorito;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    esFavorito
                        ? "Agregado a favoritos ❤️"
                        : "Eliminado de favoritos",
                  ),
                ),
              );
            },
          ),

          // 🛒 CARRITO
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CarritoScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🖼 IMAGEN
            Image.network(
              plato["imagen"],
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 15),

            // 🍽 NOMBRE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                plato["nombre"],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 💰 PRECIO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "\$ ${precioTotal.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 📝 DESCRIPCIÓN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                plato["descripcion"],
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 15),

            // 🏢 EMPRESA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Empresa: ${plato["empresa"]}",
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 EXTRAS
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Extras disponibles:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            Column(
              children: (ingredientes as List).map<Widget>((ing) {

                int id = ing["id"];
                cantidades[id] = cantidades[id] ?? 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Expanded(
                        child: Text("${ing["nombre"]} (+\$${ing["precio"]})"),
                      ),

                      Row(
                        children: [

                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (cantidades[id]! > 0) {
                                cantidades[id] = cantidades[id]! - 1;
                                recalcularTotal();
                              }
                            },
                          ),

                          Text("${cantidades[id]}"),

                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              cantidades[id] = cantidades[id]! + 1;
                              recalcularTotal();
                            },
                          ),

                        ],
                      )
                    ],
                  ),
                );

              }).toList(),
            ),

            const SizedBox(height: 25),

            // 🔥 BOTONES
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  // 🛒 AGREGAR
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {

                        List extrasSeleccionados = [];

                        cantidades.forEach((id, cantidad) {
                          if (cantidad > 0) {
                            final ingrediente = ingredientes.firstWhere((i) => i["id"] == id);
                            extrasSeleccionados.add({
                              "id": id,
                              "nombre": ingrediente["nombre"],
                              "precio": ingrediente["precio"],
                              "cantidad": cantidad
                            });
                          }
                        });

                        CarritoService.agregar(plato, extras: extrasSeleccionados);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Agregado al carrito 🛒"),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text("Añadir al carrito"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ⚡ ORDENAR
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {

                        List extrasSeleccionados = [];

                        cantidades.forEach((id, cantidad) {
                          if (cantidad > 0) {
                            final ingrediente = ingredientes.firstWhere((i) => i["id"] == id);
                            extrasSeleccionados.add({
                              "id": id,
                              "nombre": ingrediente["nombre"],
                              "precio": ingrediente["precio"],
                              "cantidad": cantidad
                            });
                          }
                        });

                        CarritoService.limpiar();
                        CarritoService.agregar(plato, extras: extrasSeleccionados);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CarritoScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text("Ordenar ahora"),
                    ),
                  ),

                ],
              ),
            ),

            // ⭐ RESEÑAS
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Reseñas ⭐",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            loadingResenas
                ? const Center(child: CircularProgressIndicator())
                : resenas.isEmpty
                    ? const Center(child: Text("Sin reseñas"))
                    : Column(
                        children: resenas.map<Widget>((r) {
                          return ListTile(
                            title: Text(r["usuario"]),
                            subtitle: Text(r["comentario"]),
                            trailing: Text("⭐ ${r["calificacion"]}"),
                          );
                        }).toList(),
                      ),

            // ✍️ NUEVA RESEÑA
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  TextField(
                    controller: comentarioCtrl,
                    decoration: const InputDecoration(
                      hintText: "Escribe tu reseña...",
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return IconButton(
                        icon: Icon(
                          i < rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            rating = i + 1;
                          });
                        },
                      );
                    }),
                  ),

                  ElevatedButton(
  onPressed: () async {

    if (comentarioCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Escribe un comentario")),
      );
      return;
    }

    bool ok = await ResenaService.crear(
      widget.plato["id"],
      comentarioCtrl.text,
      rating,
    );

    if (ok) {
      comentarioCtrl.clear();

      setState(() {
        rating = 5;
      });

      cargarResenas();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reseña enviada ⭐")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ya hiciste una reseña ❌")),
      );
    }
  },
  child: const Text("Enviar reseña"),
),

                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}