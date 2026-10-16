extends CharacterBody2D

@onready var pj: Sprite2D = $Sprite2D
#@onready var bala : PackedScene = preload("res://src/scenes/Entidades/Bala/Bala.tscn")
# Constantes del pj

@onready var cam: Camera2D = $Camera2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
# variables configurables
@export var doble_salto : int = 0
@export var bala : PackedScene

#propiedades de mi player
@export var vida: int = 5

# variables para recibir daño
@export var golpe:int = 500
@export var altura:int = -150
@export var duracion_del_golpe :float = 0.3

var tiempo_del_golpe:float = 0.0

#variables para efecto sacudir camara
var shake_tiempo : float = 0.0
@export var shake :int = 20


# variables generales
var ultima_posicion_x : float = 1.0 #derecha



func _physics_process(delta: float) -> void:
	
	manager_shake_camara(delta)
	
	if tiempo_del_golpe > 0:
		tiempo_del_golpe -= delta
		move_and_slide()
		return
	
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
func recibir_danio(danio, posicion_enemigo):
	var direccion_del_golpe = sign(global_position.x - posicion_enemigo.x)
	vida -= danio
	print(vida)
	sacudir_camara()
	
	velocity.x = direccion_del_golpe * golpe
	velocity.y = altura
	tiempo_del_golpe = duracion_del_golpe
	
	if vida <= 0:
		print("perdi")
		get_tree().reload_current_scene()

func manager_shake_camara(delta):
	if shake_tiempo > 0:
		shake_tiempo -= delta
		cam.offset = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))
	else:
		cam.offset = Vector2.ZERO

func sacudir_camara():
	shake_tiempo = 0.3
	
	
	
