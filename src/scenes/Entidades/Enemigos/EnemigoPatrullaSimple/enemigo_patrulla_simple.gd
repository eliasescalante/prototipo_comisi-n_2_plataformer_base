extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var distancia : float = 50.0
@export var direccion_inicial : int = 1
@export var velocidad : float = 100.0

var punto_de_inicio_en_x : float
var direccion_actual : int

func _ready() -> void:
	punto_de_inicio_en_x = global_position.x
	direccion_actual = direccion_inicial

func _physics_process(delta: float) -> void:
	patrullar(delta)
	move_and_slide()

func patrullar(delta):
	comprobar_limite_de_distancia()
	actualizar_animaciones(direccion_actual)
	velocity.x = direccion_actual * velocidad

func comprobar_limite_de_distancia():
	if abs(global_position.x - punto_de_inicio_en_x) >= distancia:
		direccion_actual *= -1

func actualizar_animaciones(direccion):
	animated_sprite_2d.play("idle")
	if direccion > 0:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
