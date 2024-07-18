extends Node2D

var cool_down : float = 2.0

func initialize(player : CharacterBody2D, _mouse_direction : Vector2) -> void :
	global_position = player.global_position

func _on_die_timer_timeout() -> void:
	queue_free()
