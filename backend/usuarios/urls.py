from django.urls import path
from .views import register, login, obtener_platos
from .views import crear_pedido
from .views import obtener_pedido_actual


urlpatterns = [
    path('register/', register),
    path('login/', login),
    path('platos/', obtener_platos),
    path('pedido/',crear_pedido),
    path('pedido/<int:usuario_id>/', obtener_pedido_actual),
]

