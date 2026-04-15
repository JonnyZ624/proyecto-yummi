class CarritoService {

  // 🛒 Lista global del carrito
  static List<Map<String, dynamic>> carrito = [];

  // ➕ AGREGAR PRODUCTO (🔥 MEJORADO)
  static void agregar(Map<String, dynamic> plato, {List extras = const []}) {

    carrito.add({
      ...plato,

      // 🔥 asegurar valores
      "cantidad": 1,
      "extras": extras,
    });
  }

  // ❌ ELIMINAR
  static void eliminar(int index) {
    if (index >= 0 && index < carrito.length) {
      carrito.removeAt(index);
    }
  }

  // 🧹 LIMPIAR
  static void limpiar() {
    carrito.clear();
  }

  // 🔥 AUMENTAR CANTIDAD
  static void aumentar(int index) {
    if (index >= 0 && index < carrito.length) {
      carrito[index]["cantidad"] =
          (carrito[index]["cantidad"] ?? 1) + 1;
    }
  }

  // 🔥 DISMINUIR CANTIDAD
  static void disminuir(int index) {
    if (index >= 0 && index < carrito.length) {

      int cantidad = carrito[index]["cantidad"] ?? 1;

      if (cantidad > 1) {
        carrito[index]["cantidad"] = cantidad - 1;
      } else {
        carrito.removeAt(index);
      }
    }
  }

  // 🔥 PRECIO POR ITEM (con extras)
  static double precioItem(Map plato) {

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

  // 💰 TOTAL GENERAL
  static double total() {
    double suma = 0;

    for (var p in carrito) {
      suma += precioItem(p);
    }

    return suma;
  }

  // 🔢 Cantidad de productos
  static int cantidad() {
    return carrito.length;
  }
}