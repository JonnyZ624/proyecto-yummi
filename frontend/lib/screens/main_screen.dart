import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'perfil_screen.dart';
import 'favoritos_screen.dart';
import 'comunidad_screen.dart';
import 'categoria_screen.dart';
import 'plato_detalle_screen.dart';
import 'seguimiento_screen.dart';
import '../services/user_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int index = 0;

  String? categoriaSeleccionada;
  Map<String, dynamic>? platoSeleccionado;
  bool enSeguimiento = false;

  @override
  Widget build(BuildContext context) {

    Widget pantallaActual;

    // 🔥 DETALLE
    if (platoSeleccionado != null) {
      pantallaActual = PlatoDetalleScreen(
        plato: platoSeleccionado!,
        onBack: () {
          setState(() {
            platoSeleccionado = null;
          });
        },
      );
    }

    // 🔥 CATEGORÍA
    else if (categoriaSeleccionada != null) {
      pantallaActual = CategoriaScreen(
        categoria: categoriaSeleccionada!,
        onBack: () {
          setState(() {
            categoriaSeleccionada = null;
          });
        },
        onSelectPlato: (plato) {
          setState(() {
            platoSeleccionado = Map<String, dynamic>.from(plato);
          });
        },
      );
    }

    // 🔥 SEGUIMIENTO
    else if (enSeguimiento) {
      pantallaActual = SeguimientoScreen(
        onBack: () {
          setState(() {
            enSeguimiento = false;
          });
        },
      );
    }

    // 🔥 TABS
    else {
      switch (index) {
        case 0:
          pantallaActual = HomeScreen(
            nombre: UserService.nombre ?? "",
            onSelectCategoria: (cat) {
              setState(() {
                categoriaSeleccionada = cat;
              });
            },
          );
          break;

        case 1:
          pantallaActual = const FavoritosScreen();
          break;

        case 2:
          pantallaActual = const ComunidadScreen();
          break;

        case 3:
          pantallaActual = const PerfilScreen();
          break;

        default:
          pantallaActual = Container();
      }
    }

    return Scaffold(
      body: pantallaActual,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.blue,
        onTap: (i) {
          setState(() {
            index = i;
            categoriaSeleccionada = null;
            platoSeleccionado = null;
            enSeguimiento = false;
          });
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