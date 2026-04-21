from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import (
    Usuario,
    Plato,
    Pedido,
    PedidoDetalle,
    Ingrediente,
    PedidoDetalleIngrediente,
    Favorito,
    Post
)

# =========================
# REGISTRO (MEJORADO)
# =========================
@api_view(['POST'])
def register(request):
    data = request.data

    nombre = data.get('nombre')
    email = data.get('email')
    password = data.get('password')
    username = data.get('username')
    telefono = data.get('telefono')
    foto = data.get('foto')

    # =========================
    # VALIDACIONES BÁSICAS
    # =========================
    if not nombre or not email or not password:
        return Response({"error": "Nombre, email y contraseña son obligatorios"}, status=400)

    # =========================
    # VALIDAR EMAIL ÚNICO
    # =========================
    if Usuario.objects.filter(email=email).exists():
        return Response({"error": "El correo ya está registrado"}, status=400)

    # =========================
    # VALIDAR USERNAME ÚNICO (SI VIENE)
    # =========================
    if username and Usuario.objects.filter(username=username).exists():
        return Response({"error": "El username ya está en uso"}, status=400)

    # =========================
    # VALOR POR DEFECTO PARA FOTO
    # =========================
    if not foto:
        foto = "https://i.imgur.com/default.png"

    # =========================
    # CREAR USUARIO
    # =========================
    usuario = Usuario.objects.create(
        nombre=nombre,
        email=email,
        password=password,
        username=username,
        telefono=telefono,
        foto=foto
    )

    return Response({
        "message": "Usuario creado correctamente",
        "usuario": {
            "id": usuario.id,
            "nombre": usuario.nombre,
            "email": usuario.email,
            "username": usuario.username,
            "telefono": usuario.telefono,
            "foto": usuario.foto
        }
    })

# =========================
# LOGIN
# =========================
@api_view(['POST'])
def login(request):
    data = request.data

    try:
        usuario = Usuario.objects.get(email=data['email'])

        if usuario.password != data['password']:
            return Response({"error": "Contraseña incorrecta"}, status=400)

        return Response({
            "id": usuario.id,
            "nombre": usuario.nombre,
            "email": usuario.email
        })

    except Usuario.DoesNotExist:
        return Response({"error": "Usuario no existe"}, status=400)


# =========================
# PERFIL
# =========================
@api_view(['GET'])
def obtener_perfil(request, usuario_id):
    try:
        usuario = Usuario.objects.get(id=usuario_id)

        return Response({
            "id": usuario.id,
            "nombre": usuario.nombre,
            "email": usuario.email,
            "username": usuario.username,
            "telefono": usuario.telefono,
            "foto": usuario.foto
        })

    except Usuario.DoesNotExist:
        return Response({"error": "Usuario no existe"}, status=404)


@api_view(['PUT'])
def editar_perfil(request, usuario_id):
    try:
        usuario = Usuario.objects.get(id=usuario_id)
        data = request.data

        usuario.nombre = data.get("nombre", usuario.nombre)
        usuario.email = data.get("email", usuario.email)
        usuario.username = data.get("username", usuario.username)
        usuario.telefono = data.get("telefono", usuario.telefono)
        usuario.foto = data.get("foto", usuario.foto)

        usuario.save()

        return Response({"message": "Perfil actualizado"})

    except Usuario.DoesNotExist:
        return Response({"error": "Usuario no existe"}, status=404)


# =========================
# PLATOS
# =========================
@api_view(['GET'])
def obtener_platos(request):
    categoria = request.GET.get('categoria')

    if categoria:
        platos = Plato.objects.filter(
            categoria__iexact=categoria.strip()
        )
    else:
        platos = Plato.objects.all()

    data = []

    for p in platos:
        data.append({
            "id": p.id,
            "nombre": p.nombre,
            "precio": str(p.precio),
            "imagen": p.imagen,
            "descripcion": p.descripcion,
            "empresa": p.empresa,
            "categoria": p.categoria,  # opcional pero útil
            "ingredientes": [
                {
                    "id": i.id,
                    "nombre": i.nombre,
                    "precio": str(i.precio)
                }
                for i in p.ingredientes.all()
            ]
        })

    return Response(data)


# =========================
# PEDIDOS
# =========================
@api_view(['POST'])
def crear_pedido(request):
    data = request.data

    try:
        usuario = Usuario.objects.get(id=data.get("usuario_id"))

        pedido = Pedido.objects.create(
            usuario=usuario,
            total=data.get("total"),
            metodo_pago=data.get("metodo_pago"),
            nombre_cliente=data.get("nombre_cliente"),
            ci=data.get("ci"),
            ubicacion=data.get("ubicacion"),
            telefono=data.get("telefono")
        )

        for p in data.get("productos", []):
            plato = Plato.objects.get(id=p["id"])

            detalle = PedidoDetalle.objects.create(
                pedido=pedido,
                plato=plato,
                cantidad=p.get("cantidad", 1)
            )

            for e in p.get("extras", []):
                ingrediente = Ingrediente.objects.get(id=e["id"])

                PedidoDetalleIngrediente.objects.create(
                    detalle=detalle,
                    ingrediente=ingrediente,
                    cantidad=e.get("cantidad", 1)
                )

        return Response({"message": "Pedido creado"})

    except Exception as e:
        return Response({"error": str(e)}, status=400)


@api_view(['GET'])
def obtener_pedido_actual(request, usuario_id):
    pedido = Pedido.objects.filter(usuario_id=usuario_id).last()

    if not pedido:
        return Response({"error": "No hay pedidos"}, status=404)

    detalles = []

    for d in pedido.pedidodetalle_set.all():
        extras = []
        for e in d.extras.all():
            extras.append({
                "nombre": e.ingrediente.nombre,
                "cantidad": e.cantidad
            })

        detalles.append({
            "plato": d.plato.nombre,
            "cantidad": d.cantidad,
            "extras": extras
        })

    return Response({
        "id": pedido.id,
        "total": pedido.total,
        "detalles": detalles
    })


# =========================
# FAVORITOS
# =========================
@api_view(['POST'])
def agregar_favorito(request):
    Favorito.objects.create(
        usuario_id=request.data.get("usuario_id"),
        plato_id=request.data.get("plato_id")
    )

    return Response({"message": "Agregado"})


@api_view(['GET'])
def obtener_favoritos(request, usuario_id):
    favoritos = Favorito.objects.filter(usuario_id=usuario_id)

    data = []
    for f in favoritos:
        data.append({
            "id": f.plato.id,
            "nombre": f.plato.nombre,
            "precio": str(f.plato.precio),
            "imagen": f.plato.imagen
        })

    return Response(data)


@api_view(['DELETE'])
def eliminar_favorito(request):
    Favorito.objects.filter(
        usuario_id=request.data.get("usuario_id"),
        plato_id=request.data.get("plato_id")
    ).delete()

    return Response({"message": "Eliminado"})


# =========================
# COMUNIDAD
# =========================
@api_view(['POST'])
def crear_post(request):
    usuario = Usuario.objects.get(id=request.data.get("usuario_id"))

    Post.objects.create(
        usuario=usuario,
        contenido=request.data.get("contenido")
    )

    return Response({"message": "Post creado"})


@api_view(['GET'])
def obtener_posts(request):
    posts = Post.objects.all().order_by('-fecha')

    data = []
    for p in posts:
        data.append({
            "usuario": p.usuario.nombre,
            "contenido": p.contenido,
            "fecha": p.fecha
        })

    return Response(data)