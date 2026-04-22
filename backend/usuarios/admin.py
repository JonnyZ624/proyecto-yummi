from django.contrib import admin
from .models import (
    Usuario,
    Plato,
    Pedido,
    PedidoDetalle,
    Ingrediente,
    PedidoDetalleIngrediente,
    Empresa
)

# =========================
# INGREDIENTES EN PLATO
# =========================
class IngredienteInline(admin.TabularInline):
    model = Ingrediente
    extra = 1


# =========================
# PLATO (UNIFICADO ✅)
# =========================
@admin.register(Plato)
class PlatoAdmin(admin.ModelAdmin):
    list_display = ("id", "nombre", "precio", "empresa")
    list_filter = ("empresa", "categoria")
    inlines = [IngredienteInline]


# =========================
# EMPRESA
# =========================
@admin.register(Empresa)
class EmpresaAdmin(admin.ModelAdmin):
    list_display = ("id", "nombre")


# =========================
# USUARIO
# =========================
admin.site.register(Usuario)


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