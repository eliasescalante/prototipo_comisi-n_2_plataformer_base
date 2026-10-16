extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var distancia : float = 100.0 # distancia de patrullaje cuando no persiga al jugador
@export var direccion_inicial : int = 1
@export var velocidad : float = 100.0
@export var rango_de_deteccion : float = 150.0 # distancia en la cual va a detectar mi jugador

var punto_de_inicio_en_x : float
var direccion_actual : int
var jugador : Node2D = null #guardo al jugador para utilizarlo despues accediendo a los metodos.
var persiguiendo : bool = false #bandera para saber si estoy persiguiendo al jugador

func _ready() -> void:
	punto_de_inicio_en_x = global_position.x
	direccion_actual = direccion_inicial
	
	if get_tree().has_group("jugador"):
		jugador = get_tree().get_first_node_in_group("jugador")
		
func _physics_process(delta: float) -> void:
	aplicar_movimiento()
	if persiguiendo:
		perseguir_jugador()
	else:
		patrullar(delta)
	move_and_slide()

func aplicar_movimiento():
	if jugador:
		var distancia_al_jugador = global_position.distance_to(jugador.global_position)
		
		if distancia_al_jugador <= rango_de_deteccion:
			persiguiendo = true
		elif persiguiendo and distancia_al_jugador > rango_de_deteccion:
			persiguiendo = false
			punto_de_inicio_en_x = global_position.x
func perseguir_jugador():
	if jugador.global_position.x > global_position.x:
		direccion_actual = 1
	else:
		direccion_actual = -1
	actualizar_animaciones(direccion_actual)
	velocity.x = direccion_actual * velocidad # formulita general para movimiento en characterbody2d
func patrullar(delta):
	comprobar_limite_de_distancia()
	actualizar_animaciones(direccion_actual)
	velocity.x = direccion_actual * velocidad
func actualizar_animaciones(direccion):
	animated_sprite_2d.play("idle")
	if direccion > 0:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
func comprobar_limite_de_distancia():
	if abs(global_position.x - punto_de_inicio_en_x) >= distancia:
		direccion_actual *= -1
