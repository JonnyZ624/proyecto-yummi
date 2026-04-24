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
      backgroundColor: const Color(0xFFF5F6F8), // 🎨 fondo suave

      // 🧭 HEADER BLANCO
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              )
            : null,
        title: const Text(
          "Seguimiento de pedidos",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Icon(Icons.search),
          SizedBox(width: 10),
        ],
      ),

      body: pedido == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 20),

                // 📍 MAPA
                Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text("Mapa del pedido 📍"),
                  ),
                ),

                const SizedBox(height: 10),

                // 🟢 CARD REPARTIDOR (ESTILO MODERNO)
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5E8C31),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/150?img=3",
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Manuel Smith",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Dirección del delivery",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    color: Colors.white, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  "20 - 25 min",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),

                      const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.phone,
                          color: Color(0xFF5E8C31),
                          size: 18,
                        ),
                      )
                    ],
                  ),
                ),

                // 🧾 DETALLE
                Expanded(
                  child: ListView(
                    children: [
                      ...pedido!["detalles"].map<Widget>((d) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${d["plato"]} x${d["cantidad"]}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                if (d["extras"].length > 0)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        d["extras"].map<Widget>((e) {
                                      return Text(
                                        "+ ${e["nombre"]} x${e["cantidad"]}",
                                        style: const TextStyle(
                                            fontSize: 12),
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
                          color: Colors.redAccent,
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}