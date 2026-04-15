from django.db import models

# Create your models here.


class Usuario(models.Model):
    nombre = models.CharField(max_length=100)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=100)

    def __str__(self):
        return self.nombre


class Ingrediente(models.Model):
    plato = models.ForeignKey(
        'Plato',
        on_delete=models.CASCADE,
        related_name='ingredientes'
    )
    nombre = models.CharField(max_length=100)
    precio = models.DecimalField(max_digits=5, decimal_places=2)

    def __str__(self):
        return f"{self.nombre} ({self.plato.nombre})"


class Plato(models.Model):
    nombre = models.CharField(max_length=100)
    precio = models.DecimalField(max_digits=5, decimal_places=2)
    categoria = models.CharField(max_length=50)
    imagen = models.URLField()

    descripcion = models.TextField(default="Delicioso plato")
    empresa = models.CharField(max_length=100, default="Restaurante X")

    def __str__(self):
        return self.nombre


class Pedido(models.Model):
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    total = models.DecimalField(max_digits=10, decimal_places=2)
    metodo_pago = models.CharField(max_length=50)  # 🔥 NUEVO
    fecha = models.DateTimeField(auto_now_add=True)
    nombre_cliente = models.CharField(max_length=100, default="")
    ci = models.CharField(max_length=20, default="")
    ubicacion = models.CharField(max_length=200, default="")
    telefono = models.CharField(max_length=20, default="")

    def __str__(self):
        return f"Pedido {self.id}"


class PedidoDetalle(models.Model):
    pedido = models.ForeignKey(Pedido, on_delete=models.CASCADE)
    plato = models.ForeignKey(Plato, on_delete=models.CASCADE)
    cantidad = models.IntegerField(default=1)

    def __str__(self):
        return self.plato.nombre