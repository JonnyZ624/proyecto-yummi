import 'package:flutter/material.dart';
import 'factura_screen.dart';

class TarjetaScreen extends StatefulWidget {
  final String metodo;
  final double total;

  const TarjetaScreen({
    super.key,
    required this.metodo,
    required this.total,
  });

  @override
  State<TarjetaScreen> createState() => _TarjetaScreenState();
}

class _TarjetaScreenState extends State<TarjetaScreen> {

  final numero = TextEditingController();
  final nombre = TextEditingController();
  final fecha = TextEditingController();
  final cvv = TextEditingController();

  @override
  void dispose() {
    numero.dispose();
    nombre.dispose();
    fecha.dispose();
    cvv.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Datos de tarjeta"),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: numero,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Número de tarjeta"),
            ),

            TextField(
              controller: nombre,
              decoration: const InputDecoration(labelText: "Nombre del propietario"),
            ),

            TextField(
              controller: fecha,
              decoration: const InputDecoration(labelText: "MM/YY"),
            ),

            TextField(
              controller: cvv,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "CVV"),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  if (numero.text.isEmpty ||
                      nombre.text.isEmpty ||
                      fecha.text.isEmpty ||
                      cvv.text.isEmpty) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Completa todos los datos ❌"),
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FacturaScreen(
                        metodo: widget.metodo,
                        total: widget.total,
                      ),
                    ),
                  );
                },
                child: const Text("Siguiente"),
              ),
            )

          ],
        ),
      ),
    );
  }
}