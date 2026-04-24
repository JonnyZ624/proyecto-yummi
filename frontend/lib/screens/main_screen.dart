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
          // ✅ AQUÍ SE ARREGLA EL BOTÓN ATRÁS
          pantallaActual = FavoritosScreen(
            onBack: () {
              setState(() {
                index = 0; // 🔙 volver a Home
              });
            },
          );
          break;
          
        case 2:
          pantallaActual = ComunidadScreen(
            onBack: () {
              setState(() {
                index = 0;
              });
            },
          );
          break;

        case 3:
          pantallaActual = PerfilScreen(
            onBack: () {
              setState(() {
                index = 0;
              });
            },
          );
          break;

        default:
          pantallaActual = Container();
      }
    }

    return Scaffold(
      body: pantallaActual,
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF2C445C),
        selectedIndex: index,
        indicatorColor: Colors.white24,
        onDestinationSelected: (i) {
          setState(() {
            index = i;
            categoriaSeleccionada = null;
            platoSeleccionado = null;
            enSeguimiento = false;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home, color: Colors.white),
            label: "Inicio",
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite, color: Colors.white),
            label: "Favoritos",
          ),
          NavigationDestination(
            icon: Icon(Icons.people, color: Colors.white),
            label: "Comunidad",
          ),
          NavigationDestination(
            icon: Icon(Icons.person, color: Colors.white),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}