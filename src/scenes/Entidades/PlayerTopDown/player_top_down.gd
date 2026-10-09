extends CharacterBody2D


@export var speed: int = 100

@export var bala : PackedScene

var ultima_posicion_x : Vector2 = Vector2.RIGHT
var ultima_direccion : Vector2 = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	aplicar_movimiento(delta)
	manejar_disparo()
	
	move_and_slide()


func aplicar_movimiento(delta):
	#aca aplicamos movimiento con el input
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != Vector2.ZERO:
		ultima_direccion = direction.normalized()
		rotation = direction.angle()
		ultima_posicion_x = direction
	
	velocity = direction * speed

func manejar_disparo():
	# dependiendo del input direccion 
	if Input.is_action_just_pressed("disparar"):
		disparar()

func disparar():
	#aca compruebo si se cargo la escena
	if bala == null:
		print("ERROR: MI BALA NO ESTA CARGADA")
		return
	# establezco la posicion en donde va a nacer mi bala
	var nueva_bala = bala.instantiate()
	#configuro mi nueva instancia en posicion y rotacion
	nueva_bala.global_position = global_position
	nueva_bala.direccion = ultima_posicion_x
	nueva_bala.rotation = ultima_posicion_x.angle()
	#agrego la instancia de la escena bala al arbol de nodos de la escena
	get_parent().add_child(nueva_bala)
