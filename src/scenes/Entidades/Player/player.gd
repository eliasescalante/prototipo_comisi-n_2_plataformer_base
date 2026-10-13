extends CharacterBody2D

@onready var pj: Sprite2D = $Sprite2D
#@onready var bala : PackedScene = preload("res://src/scenes/Entidades/Bala/Bala.tscn")
# Constantes del pj
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
# variables configurables
@export var doble_salto : int = 0
@export var bala : PackedScene
# variables generales
var ultima_posicion_x : float = 1.0 #derecha

func _physics_process(delta: float) -> void:
	aplicar_gravedad(delta)
	aplicar_salto(delta)
	manejar_movimiento()
	manejar_disparo()
	#para aplicar el movimiento
	move_and_slide()

#------------------------------ funciones principales para habilidades de mi pj ----------------------
func aplicar_gravedad(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

func aplicar_salto(delta):
	if is_on_floor():
		doble_salto = 2
		pj.rotation = 0
	else:
		pj.rotation += 360 * delta

	if Input.is_action_just_pressed("saltar") and doble_salto > 0:
		velocity.y = JUMP_VELOCITY
		doble_salto -= 1

func manejar_movimiento():
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		ultima_posicion_x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func manejar_disparo():
	if Input.is_action_just_pressed("disparar"):
		disparar()
# -------------------------------funciones auxiliares--------------------------------------------------
func disparar():
	#valido la instancia de bala
	if bala == null:
		print("ERROR: MI BALA NO ESTA CARGADA")
		return
	# establezco la posicion en donde va a nacer mi bala
	var nueva_bala = bala.instantiate()
	#configuro la posicion y direccion de la nueva escena instanciada
	nueva_bala.global_position = global_position
	var dir_disparo = Vector2(ultima_posicion_x, 0)
	
	nueva_bala.direccion = dir_disparo
	nueva_bala.rotation = dir_disparo.angle()
	#agrego la escena nueva al arbol de ejecucion de nodos.
	get_parent().add_child(nueva_bala)
	
	
	
