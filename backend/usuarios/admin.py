from django.contrib import admin
from .models import (
    Usuario,
    Plato,
    Pedido,
    PedidoDetalle,
    Ingrediente,
    PedidoDetalleIngrediente  # 🔥 IMPORTANTE
)


# =========================
# INGREDIENTES EN PLATO
# =========================
class IngredienteInline(admin.TabularInline):
    model = Ingrediente
    extra = 1


class PlatoAdmin(admin.ModelAdmin):
    inlines = [IngredienteInline]


# =========================
# USUARIO
# =========================
admin.site.register(Usuario)


# =========================
# PLATO
# =========================
admin.site.register(Plato, PlatoAdmin)


# =========================
# 🔥 EXTRAS EN DETALLE
# =========================
class PedidoDetalleIngredienteInline(admin.TabularInline):
    model = PedidoDetalleIngrediente
    extra = 0


# =========================
# 🔥 DETALLE (CON EXTRAS)
# =========================
class PedidoDetalleAdmin(admin.ModelAdmin):
    list_display = ("pedido", "plato", "cantidad", "tiene_extras")
    inlines = [PedidoDetalleIngredienteInline]

    def tiene_extras(self, obj):
        return obj.extras.exists()

    tiene_extras.boolean = True


admin.site.register(PedidoDetalle, PedidoDetalleAdmin)


# =========================
# 🔥 DETALLE INLINE EN PEDIDO
# =========================
class PedidoDetalleInline(admin.TabularInline):
    model = PedidoDetalle
    extra = 0


# =========================
# 🔥 PEDIDO
# =========================
class PedidoAdmin(admin.ModelAdmin):
    list_display = ("id", "usuario", "total", "fecha", "metodo_pago")
    inlines = [PedidoDetalleInline]


admin.site.register(Pedido, PedidoAdmin)