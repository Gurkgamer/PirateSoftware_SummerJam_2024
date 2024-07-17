extends CharacterBody2D

const SPEED = 300.0
const PROYECTIL = preload("res://Scenes/AlchemySpells/Test/proyectil.tscn")

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("Left","Right","Up","Down")	
	
	global_position += direction * delta * SPEED

	#move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Cast"):
		var bala = PROYECTIL.instantiate()
		bala.global_position = global_position
		var direccion_bala = (get_global_mouse_position() - position).normalized()
		bala.set_direction(direccion_bala)
		get_tree().root.add_child(bala)
