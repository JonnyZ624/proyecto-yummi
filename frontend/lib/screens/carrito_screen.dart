import 'package:flutter/material.dart';
import 'package:frontend/services/carrito_service.dart';
import 'package:frontend/screens/metodo_pago_screen.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {

  // 🔥 CALCULAR TOTAL GENERAL
  double calcularTotal() {
    double total = 0;

    for (var p in CarritoService.carrito) {

      double precioBase = double.parse(p["precio"].toString());

      double extras = 0;
      if (p["extras"] != null) {
        for (var e in p["extras"]) {
          extras += double.parse(e["precio"].toString());
        }
      }

      int cantidad = p["cantidad"] ?? 1;

      total += (precioBase + extras) * cantidad;
    }

    return total;
  }

  // 🔥 CALCULAR TOTAL POR PRODUCTO
  double calcularPrecioItem(Map plato) {

    double precioBase = double.parse(plato["precio"].toString());

    double extras = 0;
    if (plato["extras"] != null) {
      for (var e in plato["extras"]) {
        extras += double.parse(e["precio"].toString());
      }
    }

    int cantidad = plato["cantidad"] ?? 1;

    return (precioBase + extras) * cantidad;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrito 🛒"),
        backgroundColor: Colors.green,
      ),

      body: CarritoService.carrito.isEmpty
          ? const Center(child: Text("El carrito está vacío"))
          : Column(
              children: [

                // 📋 LISTA
                Expanded(
                  child: ListView.builder(
                    itemCount: CarritoService.carrito.length,
                    itemBuilder: (context, index) {

                      if (index >= CarritoService.carrito.length) {
                        return const SizedBox();
                      }

                      final plato = CarritoService.carrito[index];

                      // 🔥 ASEGURAR VALORES
                      plato["cantidad"] ??= 1;

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [

                              Image.network(
                                plato["imagen"],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),

                              const SizedBox(width: 10),

                              // INFO
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      plato["nombre"],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    Text(
                                      "\$ ${calcularPrecioItem(plato).toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),

                                    // 🔥 EXTRAS
                                    if (plato["extras"] != null)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: plato["extras"].map<Widget>((e) {
                                          return Text(
                                            "+ ${e["nombre"]} (\$${e["precio"]})",
                                            style: const TextStyle(fontSize: 12),
                                          );
                                        }).toList(),
                                      ),

                                    // 🔥 CONTROLES
                                    Row(
                                      children: [

                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {

                                            setState(() {

                                              int cantidad = plato["cantidad"] ?? 1;

                                              if (cantidad > 1) {
                                                plato["cantidad"] = cantidad - 1;
                                              } else {
                                                CarritoService.eliminar(index);
                                              }

                                            });
                                          },
                                        ),

                                        Text("${plato["cantidad"]}"),

                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {

                                            setState(() {
                                              plato["cantidad"] =
                                                  (plato["cantidad"] ?? 1) + 1;
                                            });

                                          },
                                        ),

                                      ],
                                    ),

                                  ],
                                ),
                              ),

                              // ❌ ELIMINAR
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    CarritoService.eliminar(index);
                                  });
                                },
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 💰 TOTAL
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [

                      Text(
                        "Total: \$ ${calcularTotal().toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 🧹 LIMPIAR
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              CarritoService.limpiar();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          child: const Text("Vaciar carrito"),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 💳 COMPRAR
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {

                            if (CarritoService.carrito.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Carrito vacío ❌"),
                                ),
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MetodoPagoScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text("Comprar"),
                        ),
                      ),

                    ],
                  ),
                )

              ],
            ),
    );
  }
}