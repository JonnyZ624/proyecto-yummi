from django.contrib import admin
from .models import Usuario, Plato, Pedido, PedidoDetalle, Ingrediente


# 🔥 INGREDIENTES DENTRO DE PLATO
class IngredienteInline(admin.TabularInline):
    model = Ingrediente
    extra = 1


# 🔥 PERSONALIZAR PLATO
class PlatoAdmin(admin.ModelAdmin):
    inlines = [IngredienteInline]


# 🔥 USUARIO
admin.site.register(Usuario)

# 🔥 PLATO CON INGREDIENTES INLINE
admin.site.register(Plato, PlatoAdmin)

# ❌ OPCIONAL: quitar Ingrediente separado
# admin.site.register(Ingrediente)


# 🔥 PEDIDO
class PedidoAdmin(admin.ModelAdmin):
    list_display = ("id", "usuario", "total", "fecha", "metodo_pago")

admin.site.register(Pedido, PedidoAdmin)


# 🔥 DETALLE
class PedidoDetalleAdmin(admin.ModelAdmin):
    list_display = ("pedido", "plato", "cantidad")

admin.site.register(PedidoDetalle, PedidoDetalleAdmin)