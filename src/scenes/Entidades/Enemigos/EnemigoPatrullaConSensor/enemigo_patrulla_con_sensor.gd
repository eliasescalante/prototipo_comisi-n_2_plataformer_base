extends CharacterBody2D

#defino mi señal y paso informacion que va a usar otra escena
signal danio_al_player(cantidad, posicion_enemigo)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2

@export var velocidad : float = 100.0
@export var gravedad : float = 989.0

var direccion: int = 1

#variables para mi enemigo
@export var danio: int = 1
@export var vida: int = 5
@export var puntos_enemigo: int = 5

func _ready() -> void:
	actualizar_animacion()

func _physics_process(delta: float) -> void:
	aplicar_movimiento(delta)
	move_and_slide()
	verificar_borde_o_pared()

func actualizar_animacion():
	animated_sprite_2d.play("idle")
	if direccion > 0:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
func aplicar_movimiento(delta):
	velocity.x = direccion * velocidad
	if not is_on_floor():
		velocity.y += gravedad * delta
func verificar_borde_o_pared():
	if is_on_floor():
		if direccion == 1 and (not ray_cast_2d.is_colliding() or is_on_wall()):
			cambiar_direccion()
		elif direccion == -1 and (not ray_cast_2d_2.is_colliding() or is_on_wall()):
			cambiar_direccion()
func cambiar_direccion():
	direccion *= -1
	actualizar_animacion()
func recibir_danio(danio):
	vida -= danio
	print("enemigo dice: ouch!")
	if vida <= 0:
		queue_free()
# señales desde mi enemigo
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		print("entro el jugador al area del enemigo")
		danio_al_player.emit(danio, global_position)
