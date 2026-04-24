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
        title: const Text(
          "Tarjeta de crédito",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 💳 IMAGEN DE TARJETA
            Container(
              width: double.infinity,
              height: 250,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage("assets/images/tarjeta.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// 📦 CARD DE FORMULARIO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [

                  campoTexto(
                    controller: numero,
                    label: "Número de tarjeta",
                    isNumber: true,
                  ),

                  const SizedBox(height: 15),

                  campoTexto(
                    controller: nombre,
                    label: "Nombre del propietario",
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(
                        child: campoTexto(
                          controller: fecha,
                          label: "MM/YY",
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: campoTexto(
                          controller: cvv,
                          label: "CVV",
                          isNumber: true,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),

            const SizedBox(height: 30),

            /// 🔘 BOTÓN
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Siguiente",
                  style: TextStyle(fontSize: 16,color: Colors.white,),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  /// ✏️ INPUT ESTILIZADO (solo línea abajo)
  Widget campoTexto({
    required TextEditingController controller,
    required String label,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}