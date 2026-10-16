extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var distancia : float = 100.0
@export var velocidad : float = 100.0

var punto_inicial_x : float
var direccion : int = 1
var jugador : Node2D = null

func _ready() -> void:
	punto_inicial_x = global_position.x

func _physics_process(_delta: float) -> void:
	calcular_la_direccion()
	# Aplicar movimiento y animaciones de forma unificada
	velocity.x = direccion * velocidad
	animated_sprite_2d.play("idle")
	animated_sprite_2d.flip_h = (direccion < 0)
	
	move_and_slide()
func calcular_la_direccion():
	# Si persigue al jugador y es válido, calcula la dirección hacia él. Si no, patrulla.
	if is_instance_valid(jugador):
		direccion = int(sign(jugador.global_position.x - global_position.x))
	else:
		if abs(global_position.x - punto_inicial_x) >= distancia:
			direccion *= -1

# --- SEÑALES ---

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == jugador:
		jugador = null
		punto_inicial_x = global_position.x # Reinicia el punto de patrulla donde salió
