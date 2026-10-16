extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var particulas: GPUParticles2D = $GPUParticles2D

@export var punto_kiwi : int = 5
@export var punto_frutilla: int = 8
@export_enum("kiwi", "frutilla") var tipo_de_item: String

var punto_del_item : int
var recolectado : bool = false

func _ready() -> void:
	reproducir_animacion()
	asignar_item()
	#animated_sprite_2d.play("kiwi")

# mis funciones para configurar el item
func asignar_item():
	if tipo_de_item == "kiwi":
		punto_del_item = punto_kiwi
	elif tipo_de_item == "frutilla":
		punto_del_item = punto_frutilla
	else:
		print("ERROR: no se eligio el tipo de item")

func reproducir_animacion():
	if tipo_de_item:
		animated_sprite_2d.play(tipo_de_item)


func _on_body_entered(body: Node2D) -> void:
	
	if recolectado:
		return
	
	if body.is_in_group("jugador"):
		recolectado =true
		
		print("entro el jugador")
		print("puntos: ", punto_kiwi )
		animated_sprite_2d.hide()
		particulas.restart()
		particulas.emitting = true
		await particulas.finished
		queue_free()
	pass # Replace with function body.
