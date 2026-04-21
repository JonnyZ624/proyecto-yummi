import 'package:flutter/material.dart';
import 'package:frontend/services/carrito_service.dart';
import 'carrito_screen.dart';
import '../services/user_service.dart';

class PlatoDetalleScreen extends StatefulWidget {
  final Map<String, dynamic> plato;

  const PlatoDetalleScreen({super.key, required this.plato});

  @override
  State<PlatoDetalleScreen> createState() => _PlatoDetalleScreenState();
}

class _PlatoDetalleScreenState extends State<PlatoDetalleScreen> {

  Map<int, int> cantidades = {};
  double precioTotal = 0;

  int index = 0; // 👈 para el navbar

  @override
  void initState() {
    super.initState();
    precioTotal = double.parse(widget.plato["precio"].toString());
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
        title: Text(plato["nombre"]),
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Image.network(
              plato["imagen"],
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                plato["nombre"],
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                plato["descripcion"],
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Empresa: ${plato["empresa"]}",
                style: const TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),

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

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

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
                          const SnackBar(content: Text("Agregado al carrito 🛒")),
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
                            builder: (context) => const CarritoScreen(),
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

            const SizedBox(height: 20),

          ],
        ),
      ),

      // 🔥 NAVBAR AQUÍ
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.blue,
        onTap: (i) {
          setState(() {
            index = i;
          });

          if (i == 0) {
            Navigator.pop(context); // volver al home
          }
          // puedes agregar navegación a favoritos, comunidad, etc aquí luego
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoritos"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Comunidad"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}