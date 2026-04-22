from django.db import models


# =========================
# USUARIO
# =========================
class Usuario(models.Model):
    nombre = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=100)

    username = models.CharField(max_length=50, unique=True, null=True, blank=True)
    telefono = models.CharField(max_length=20, blank=True, default="")
    foto = models.URLField(blank=True, default="")

    def __str__(self):
        return self.nombre


# =========================
# 📂 CATEGORÍAS (SELECT)
# =========================
CATEGORIAS = [
    ("Desayuno", "Desayuno"),
    ("Almuerzo", "Almuerzo"),
    ("Cena", "Cena"),
    ("Frutas", "Frutas"),
    ("Vegetales", "Vegetales"),
    ("Proteínas", "Proteínas"),
]


# =========================
# Empresa
# =========================
class Empresa(models.Model):
    nombre = models.CharField(max_length=100)
    imagen = models.URLField(blank=True, null=True)

    def __str__(self):
        return self.nombre


# =========================
# 🍽 PLATOS
# =========================
class Plato(models.Model):
    nombre = models.CharField(max_length=100)
    precio = models.DecimalField(max_digits=5, decimal_places=2)

    categoria = models.CharField(
        max_length=50,
        choices=CATEGORIAS
    )

    imagen = models.URLField()
    descripcion = models.TextField(default="Delicioso plato")

    # ✅ RELACIÓN REAL
    empresa = models.ForeignKey(
        Empresa,
        on_delete=models.CASCADE,
        null=True,
        blank=True
    )

    def __str__(self):
        return self.nombre


# =========================
# INGREDIENTES
# =========================
class Ingrediente(models.Model):
    plato = models.ForeignKey(
        Plato,
        on_delete=models.CASCADE,
        related_name='ingredientes'
    )
    nombre = models.CharField(max_length=100)
    precio = models.DecimalField(max_digits=5, decimal_places=2)

    def __str__(self):
        return f"{self.nombre} ({self.plato.nombre})"


# =========================
# PEDIDOS
# =========================
class Pedido(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    total = models.DecimalField(max_digits=10, decimal_places=2)
    metodo_pago = models.CharField(max_length=50)
    fecha = models.DateTimeField(auto_now_add=True)

    nombre_cliente = models.CharField(max_length=100, default="")
    ci = models.CharField(max_length=20, default="")
    ubicacion = models.CharField(max_length=200, default="")
    telefono = models.CharField(max_length=20, default="")

    def __str__(self):
        return f"Pedido {self.id}"


# =========================
# DETALLE PEDIDO
# =========================
class PedidoDetalle(models.Model):
    pedido = models.ForeignKey(Pedido, on_delete=models.CASCADE)
    plato = models.ForeignKey(Plato, on_delete=models.CASCADE)
    cantidad = models.IntegerField(default=1)

    def __str__(self):
        return self.plato.nombre


# =========================
# EXTRAS
# =========================
class PedidoDetalleIngrediente(models.Model):
    detalle = models.ForeignKey(
        PedidoDetalle,
        on_delete=models.CASCADE,
        related_name='extras'
    )
    ingrediente = models.ForeignKey(
        Ingrediente,
        on_delete=models.CASCADE
    )
    cantidad = models.IntegerField(default=1)

    def __str__(self):
        return f"{self.ingrediente.nombre} x{self.cantidad}"


# =========================
# FAVORITOS
# =========================
class Favorito(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    plato = models.ForeignKey(Plato, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.usuario.nombre} ❤️ {self.plato.nombre}"


# =========================
# COMUNIDAD
# =========================
class Post(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    contenido = models.TextField()
    fecha = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.usuario.nombre}: {self.contenido[:30]}"




# =========================
# ⭐ RESEÑAS
# =========================
class Resena(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    plato = models.ForeignKey(Plato, on_delete=models.CASCADE)
    comentario = models.TextField()
    calificacion = models.IntegerField(default=5)
    fecha = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('usuario', 'plato')  # 🔥 evita duplicados a nivel BD

    def __str__(self):
        return f"{self.usuario.nombre} - {self.plato.nombre}"




