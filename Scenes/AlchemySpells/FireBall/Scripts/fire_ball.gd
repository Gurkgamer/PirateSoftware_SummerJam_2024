extends Node2D

var direction : Vector2
var speed : float = 1500.0
var cast_distance_from_player : float = 50.0
var cool_down : float = 0.2

func _process(delta: float) -> void:
	position += delta * direction * speed

func initialize(player: CharacterBody2D, p_direction : Vector2) -> void:
	direction = p_direction
	rotation = p_direction.angle()
	print(rad_to_deg(rotation))
	%CPUParticles2D.angle_max = -rad_to_deg(rotation)
	%CPUParticles2D.angle_min = -rad_to_deg(rotation)
	%CPUParticles2D.gravity = p_direction * speed / 8
	global_position = player.global_position + Vector2(cast_distance_from_player,0)

func _on_die_timer_timeout() -> void:
	queue_free()
