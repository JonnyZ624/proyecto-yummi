from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import Usuario, Plato, Pedido, PedidoDetalle, Ingrediente, PedidoDetalleIngrediente


# =========================
# REGISTRO
# =========================
@api_view(['POST'])
def register(request):
    data = request.data

    if not data.get('nombre') or not data.get('email') or not data.get('password'):
        return Response({"error": "Todos los campos son obligatorios"}, status=400)

    if Usuario.objects.filter(email=data['email']).exists():
        return Response({"error": "El correo ya está registrado"}, status=400)

    Usuario.objects.create(
        nombre=data['nombre'],
        email=data['email'],
        password=data['password']
    )

    return Response({"message": "Usuario creado correctamente"})


# =========================
# LOGIN
# =========================
@api_view(['POST'])
def login(request):
    data = request.data

    if not data.get('email') or not data.get('password'):
        return Response({"error": "Email y contraseña son obligatorios"}, status=400)

    try:
        usuario = Usuario.objects.get(email=data['email'])

        if usuario.password != data['password']:
            return Response({"error": "Contraseña incorrecta"}, status=400)

        return Response({
            "message": "Login exitoso",
            "nombre": usuario.nombre,
            "email": usuario.email,
            "id": usuario.id
        })

    except Usuario.DoesNotExist:
        return Response({"error": "Usuario no existe"}, status=400)


# =========================
# OBTENER PLATOS
# =========================
@api_view(['GET'])
def obtener_platos(request):
    categoria = request.GET.get('categoria')

    if categoria:
        platos = Plato.objects.filter(categoria=categoria)
    else:
        platos = Plato.objects.all()

    data = []

    for p in platos:
        data.append({
            "id": p.id,
            "nombre": p.nombre,
            "precio": str(p.precio),
            "categoria": p.categoria,
            "imagen": p.imagen,
            "descripcion": p.descripcion,
            "empresa": p.empresa,

            # 🔥 INGREDIENTES
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
# CREAR PEDIDO (🔥 PRO)
# =========================
@api_view(['POST'])
def crear_pedido(request):
    data = request.data

    usuario_id = data.get("usuario_id")
    productos = data.get("productos")
    total = data.get("total")
    metodo_pago = data.get("metodo_pago")

    # 🔥 DATOS FACTURA
    nombre_cliente = data.get("nombre_cliente")
    ci = data.get("ci")
    ubicacion = data.get("ubicacion")
    telefono = data.get("telefono")

    # =========================
    # VALIDACIONES
    # =========================
    if not usuario_id:
        return Response({"error": "Falta usuario_id"}, status=400)

    if not productos or len(productos) == 0:
        return Response({"error": "No hay productos"}, status=400)

    try:
        total = float(total)
        if total <= 0:
            return Response({"error": "Total inválido"}, status=400)
    except:
        return Response({"error": "Total inválido"}, status=400)

    if not metodo_pago:
        return Response({"error": "Falta método de pago"}, status=400)

    if not nombre_cliente or not ci or not ubicacion or not telefono:
        return Response({"error": "Faltan datos de factura"}, status=400)

    try:
        usuario = Usuario.objects.get(id=usuario_id)

        # =========================
        # CREAR PEDIDO
        # =========================
        pedido = Pedido.objects.create(
            usuario=usuario,
            total=total,
            metodo_pago=metodo_pago,
            nombre_cliente=nombre_cliente,
            ci=ci,
            ubicacion=ubicacion,
            telefono=telefono
        )

        # =========================
        # DETALLES + EXTRAS 🔥
        # =========================
        for p in productos:
            plato = Plato.objects.get(id=p["id"])

            detalle = PedidoDetalle.objects.create(
                pedido=pedido,
                plato=plato,
                cantidad=p.get("cantidad", 1)
            )

            # 🔥 EXTRAS POR PRODUCTO
            extras = p.get("extras", [])

            for e in extras:
                try:
                    ingrediente = Ingrediente.objects.get(id=e["id"])

                    PedidoDetalleIngrediente.objects.create(
                        detalle=detalle,
                        ingrediente=ingrediente,
                        cantidad=e.get("cantidad", 1)
                    )

                except Ingrediente.DoesNotExist:
                    pass

        return Response({
            "message": "Pedido guardado correctamente"
        })

    except Usuario.DoesNotExist:
        return Response({"error": "Usuario no existe"}, status=400)

    except Plato.DoesNotExist:
        return Response({"error": "Plato no existe"}, status=400)

    except Exception as e:
        return Response({
            "error": str(e)
        }, status=400)



# =========================
# OBTENER ÚLTIMO PEDIDO
# =========================
@api_view(['GET'])
def obtener_pedido_actual(request, usuario_id):
    try:
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
            "metodo_pago": pedido.metodo_pago,
            "detalles": detalles
        })

    except Exception as e:
        return Response({"error": str(e)}, status=400)