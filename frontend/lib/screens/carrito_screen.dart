import 'package:flutter/material.dart';
import 'package:frontend/services/carrito_service.dart';
import 'package:frontend/screens/metodo_pago_screen.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {

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
        title: const Text("Carrito"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      backgroundColor: Colors.white,

      body: CarritoService.carrito.isEmpty
          ? const Center(child: Text("El carrito está vacío"))
          : Column(
              children: [

                // 📋 LISTA
                Expanded(
                  child: ListView.builder(
                    itemCount: CarritoService.carrito.length,
                    itemBuilder: (context, index) {

                      final plato = CarritoService.carrito[index];
                      plato["cantidad"] ??= 1;

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [

                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                plato["imagen"],
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    plato["nombre"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    "\$ ${calcularPrecioItem(plato).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 13,
                                    ),
                                  ),

                                  if (plato["extras"] != null)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          plato["extras"].map<Widget>((e) {
                                        return Text(
                                          "+ ${e["nombre"]} (\$${e["precio"]})",
                                          style: const TextStyle(
                                              fontSize: 11),
                                        );
                                      }).toList(),
                                    ),

                                  const SizedBox(height: 5),

                                  Row(
                                    children: [

                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.purple,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.remove,
                                              color: Colors.white,
                                              size: 16),
                                          onPressed: () {
                                            setState(() {
                                              int cantidad =
                                                  plato["cantidad"] ?? 1;

                                              if (cantidad > 1) {
                                                plato["cantidad"] =
                                                    cantidad - 1;
                                              } else {
                                                CarritoService
                                                    .eliminar(index);
                                              }
                                            });
                                          },
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      Text("${plato["cantidad"]}"),

                                      const SizedBox(width: 8),

                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.purple,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.add,
                                              color: Colors.white,
                                              size: 16),
                                          onPressed: () {
                                            setState(() {
                                              plato["cantidad"] =
                                                  (plato["cantidad"] ??
                                                          1) +
                                                      1;
                                            });
                                          },
                                        ),
                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),

                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  CarritoService.eliminar(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // 💰 ORDEN MEJORADO
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 20), // 👈 más grande
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Orden",
                        style: TextStyle(
                          fontSize: 18, // 👈 más grande
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),

                      const SizedBox(height: 15),

                      filaPrecio("Subtotal", calcularTotal()),
                      filaPrecio("Delivery", 0),

                      const Divider(height: 25),

                      filaPrecio("Total", calcularTotal(), bold: true),

                      const SizedBox(height: 20),

                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MetodoPagoScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                          ),
                          child: const Text(
                            "Procesar el pago",
                            style: TextStyle(
                              color: Colors.white, // 👈 blanco
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget filaPrecio(String titulo, double valor,
      {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6), // 👈 más espacio
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 15), // 👈 más grande
          ),
          Text(
            "\$${valor.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 15,
              fontWeight:
                  bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}