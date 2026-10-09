extends Area2D

@onready var ani: AnimatedSprite2D = $AnimatedSprite2D

@export var velocidad : float = 400.0

var direccion : Vector2 = Vector2.RIGHT

func _ready() -> void:
	ani.play("idle")

func _physics_process(delta: float) -> void:
	position += direccion * velocidad * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
