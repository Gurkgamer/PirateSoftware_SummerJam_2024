extends Node2D

var player : CharacterBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = player.global_position
	rotate(1.0)

func initialize(p_player : CharacterBody2D, grad: float)-> void:
	player = p_player
	%Sprite2D.offset.x +=  50
	rotate(grad)
