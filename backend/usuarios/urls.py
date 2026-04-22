from django.urls import path
from .views import *

urlpatterns = [
    path('register/', register),
    path('login/', login),

    path('perfil/<int:usuario_id>/', obtener_perfil),
    path('perfil/editar/<int:usuario_id>/', editar_perfil),

    path('platos/', obtener_platos),

    path('pedido/', crear_pedido),
    path('pedido/<int:usuario_id>/', obtener_pedido_actual),

    path('favorito/', agregar_favorito),
    path('favorito/<int:usuario_id>/', obtener_favoritos),
    path('favorito/eliminar/', eliminar_favorito),

    path('post/', crear_post),
    path('posts/', obtener_posts),

    path('resena/', crear_resena),
    path('resenas/<int:plato_id>/', obtener_resenas),
    path('plato/<int:plato_id>/', obtener_plato),
    path('favorito/check/<int:usuario_id>/<int:plato_id>/', es_favorito),
    path('resena/', crear_resena),
    path('resena/<int:plato_id>/', obtener_resenas),
]
