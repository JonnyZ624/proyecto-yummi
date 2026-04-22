import 'package:flutter/material.dart';
import '../services/plato_service.dart';
import 'plato_detalle_screen.dart';

class EmpresaPlatosScreen extends StatefulWidget {
  final String empresa;

  const EmpresaPlatosScreen({super.key, required this.empresa});

  @override
  State<EmpresaPlatosScreen> createState() => _EmpresaPlatosScreenState();
}

class _EmpresaPlatosScreenState extends State<EmpresaPlatosScreen> {

  List platos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  void cargar() async {
    final data = await PlatoService.obtenerPorEmpresa(widget.empresa);

    setState(() {
      platos = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(widget.empresa),
        backgroundColor: Colors.green,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : platos.isEmpty
              ? const Center(child: Text("No hay platos"))
              : ListView.builder(
                  itemCount: platos.length,
                  itemBuilder: (context, index) {

                    final p = platos[index];

                    return ListTile(
                      leading: Image.network(
                        p["imagen"],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(p["nombre"]),
                      subtitle: Text("\$${p["precio"]}"),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlatoDetalleScreen(plato: p),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}