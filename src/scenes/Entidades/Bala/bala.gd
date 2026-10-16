extends Area2D

signal impacto(danio)

@onready var ani: AnimatedSprite2D = $AnimatedSprite2D
@export var velocidad : float = 400.0
@export var danio :int =1

var direccion : Vector2 = Vector2.RIGHT

func _ready() -> void:
	#reproduzco la animacion inicial
	ani.play("idle")

func _physics_process(delta: float) -> void:
	mover_horizontalmente(delta)

#--------------------------------funciones----------------------------------------
func mover_horizontalmente(delta):
	position += direccion * velocidad * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemigo"):
		impacto.connect(body.recibir_danio)
		impacto.emit(danio)
		queue_free()
	pass # Replace with function body.
