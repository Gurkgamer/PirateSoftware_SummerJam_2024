extends Node2D

var player_global_position
var mouse_vector
const IVY = preload("res://Scenes/AlchemySpells/Ivystream/ivy.tscn")

var cooldown = 3.0

var num_ivys : int = 3
var max_ivys : int = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%NextIvy.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func initialize(p_player : CharacterBody2D, mouse_direction : Vector2) -> void:	
	player_global_position = p_player.global_position		
	mouse_vector = mouse_direction

func _on_next_ivy_timeout() -> void:
	if num_ivys <= max_ivys :
		var new_ivy = IVY.instantiate()		
		new_ivy.global_position = player_global_position + num_ivys * 25 * mouse_vector
		%NextIvy.start()
		add_child(new_ivy)
		num_ivys +=1


func _on_die_timer_timeout() -> void:
	queue_free()
