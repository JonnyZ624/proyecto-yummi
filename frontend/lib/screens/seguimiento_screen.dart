import 'package:flutter/material.dart';
import 'package:frontend/services/pedido_service.dart';

class SeguimientoScreen extends StatefulWidget {

  final Function()? onBack;

  const SeguimientoScreen({super.key, this.onBack});

  @override
  State<SeguimientoScreen> createState() => _SeguimientoScreenState();
}

class _SeguimientoScreenState extends State<SeguimientoScreen> {

  Map<String, dynamic>? pedido;

  @override
  void initState() {
    super.initState();
    cargarPedido();
  }

  void cargarPedido() async {
    final data = await PedidoService.obtenerPedidoActual();

    setState(() {
      pedido = data;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              )
            : null,
        title: const Text("Seguimiento"),
        backgroundColor: Colors.green,
      ),

      body: pedido == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [

                const SizedBox(height: 20),

                // 📍 MAPA
                Container(
                  height: 200,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text("Mapa del pedido 📍"),
                  ),
                ),

                // 🧾 DETALLE
                Expanded(
                  child: ListView(
                    children: [

                      ...pedido!["detalles"].map<Widget>((d) {

                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  "${d["plato"]} x${d["cantidad"]}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                if (d["extras"].length > 0)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: d["extras"].map<Widget>((e) {
                                      return Text(
                                        "+ ${e["nombre"]} x${e["cantidad"]}",
                                        style: const TextStyle(fontSize: 12),
                                      );
                                    }).toList(),
                                  )

                              ],
                            ),
                          ),
                        );

                      }).toList(),

                      const SizedBox(height: 10),

                      Text(
                        "Total: \$${pedido!["total"]}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Repartidor: Juan Pérez", style: TextStyle(color: Colors.white)),
                            SizedBox(height: 5),
                            Text("Tiempo estimado: 20-25 min", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      )

                    ],
                  ),
                )

              ],
            ),
    );
  }
}