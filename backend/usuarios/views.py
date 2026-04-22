from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import Resena
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
        print("🔍 ID RECIBIDO:", usuario_id)

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
        print("❌ USUARIO NO EXISTE CON ID:", usuario_id)
        return Response({"error": "Usuario no existe"}, status=404)

    except Exception as e:
        print("🔥 ERROR REAL EN PERFIL:", str(e))
        return Response({"error": str(e)}, status=500)


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
            "empresa": p.empresa.nombre if p.empresa else None,
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




@api_view(['POST'])
def crear_resena(request):
    usuario = Usuario.objects.get(id=request.data.get("usuario_id"))
    plato = Plato.objects.get(id=request.data.get("plato_id"))

    Resena.objects.create(
        usuario=usuario,
        plato=plato,
        comentario=request.data.get("comentario"),
        calificacion=request.data.get("calificacion", 5)
    )

    return Response({"message": "Reseña creada"})


@api_view(['GET'])
def obtener_resenas(request, plato_id):
    resenas = Resena.objects.filter(plato_id=plato_id).order_by('-fecha')

    data = []

    for r in resenas:
        data.append({
            "usuario": r.usuario.nombre,
            "comentario": r.comentario,
            "calificacion": r.calificacion,
            "fecha": r.fecha
        })

    return Response(data)




@api_view(['GET'])
def obtener_plato(request, plato_id):
    try:
        p = Plato.objects.get(id=plato_id)

        return Response({
            "id": p.id,
            "nombre": p.nombre,
            "precio": str(p.precio),
            "imagen": p.imagen,
            "descripcion": p.descripcion,
            "empresa": p.empresa.nombre if p.empresa else None,
            "ingredientes": [
                {
                    "id": i.id,
                    "nombre": i.nombre,
                    "precio": str(i.precio)
                }
                for i in p.ingredientes.all()
            ]
        })

    except Plato.DoesNotExist:
        return Response({"error": "No existe"}, status=404)



@api_view(['GET'])
def es_favorito(request, usuario_id, plato_id):
    existe = Favorito.objects.filter(
        usuario_id=usuario_id,
        plato_id=plato_id
    ).exists()

    return Response({"favorito": existe})



from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import Resena, Usuario, Plato

# =========================
# ⭐ CREAR RESEÑA
# =========================
@api_view(['POST'])
def crear_resena(request):
    try:
        usuario_id = request.data.get("usuario_id")
        plato_id = request.data.get("plato_id")
        comentario = request.data.get("comentario")
        calificacion = int(request.data.get("calificacion", 5))  # 🔥 asegurar int

        usuario = Usuario.objects.get(id=usuario_id)
        plato = Plato.objects.get(id=plato_id)

        # 🚫 evitar duplicados
        if Resena.objects.filter(usuario=usuario, plato=plato).exists():
            return Response({"error": "Ya hiciste una reseña"}, status=400)

        Resena.objects.create(
            usuario=usuario,
            plato=plato,
            comentario=comentario,
            calificacion=calificacion
        )

        return Response({"success": True, "message": "Reseña creada"})

    except Exception as e:
        return Response({"success": False, "error": str(e)}, status=400)


# =========================
# ⭐ OBTENER RESEÑAS
# =========================
@api_view(['GET'])
def obtener_resenas(request, plato_id):
    resenas = Resena.objects.filter(plato_id=plato_id).order_by('-fecha')

    data = []
    for r in resenas:
        data.append({
            "usuario": r.usuario.nombre,
            "comentario": r.comentario,
            "calificacion": r.calificacion,
            "fecha": r.fecha.strftime("%Y-%m-%d %H:%M")  # 🔥 mejor formato
        })

    return Response(data)