extends CharacterBody2D

@onready var pj: Sprite2D = $Sprite2D
#@onready var bala : PackedScene = preload("res://src/scenes/Entidades/Bala/Bala.tscn")
# Constantes del pj
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
# variables configurables
@export var doble_salto : int = 0
@export var bala : PackedScene

var ultima_posicion_x : float = 1.0 #derecha

func _physics_process(delta: float) -> void:
	aplicar_gravedad(delta)
	aplicar_salto(delta)
	manejar_movimiento()
	manejar_disparo()
	
	move_and_slide()

#------------------------------ funciones principales para habilidades de mi pj ----------------------
func aplicar_gravedad(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

func aplicar_salto(delta):
	if is_on_floor():
		doble_salto = 2
		pj.rotation = 0
	else:
		pj.rotation += 360 * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("saltar") and doble_salto > 0:
		velocity.y = JUMP_VELOCITY
		doble_salto -= 1

func manejar_movimiento():
		# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		ultima_posicion_x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func manejar_disparo():
	if Input.is_action_just_pressed("disparar"):
		disparar()
# -------------------------------funcion auxiliar--------------------------------------------------
func disparar():
	#valido la instancia de bala
	if bala == null:
		print("ERROR: MI BALA NO ESTA CARGADA")
		return
	# establezco la posicion en donde va a nacer mi bala
	var nueva_bala = bala.instantiate()
	
	nueva_bala.global_position = global_position
	print(nueva_bala.direccion)
	
	var dir_disparo = Vector2(ultima_posicion_x, 0)
	
	nueva_bala.direccion = dir_disparo
	nueva_bala.rotation = dir_disparo.angle()
	
	print(nueva_bala.direccion)
	get_parent().add_child(nueva_bala)
	
	
	
