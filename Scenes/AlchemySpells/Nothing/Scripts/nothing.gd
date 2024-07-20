extends Node2D

var cooldown : float = 0.01

func _ready() -> void:
	queue_free()

func initialize(player: CharacterBody2D, _p_direction : Vector2) -> void:
	global_position = player.global_position
