extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var enemigo_patrulla_con_sensor: CharacterBody2D = $Enemigos/EnemigoPatrullaConSensor


func _ready() -> void:
	enemigo_patrulla_con_sensor.danio_al_player.connect(player.recibir_danio)
