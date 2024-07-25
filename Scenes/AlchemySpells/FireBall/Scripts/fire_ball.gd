extends Node2D

var direction : Vector2
var speed : float = 1500.0
var cooldown : float = 0.2
var damage : int = 3

func _process(delta: float) -> void:
	position += delta * direction * speed

func initialize(player: CharacterBody2D, p_direction : Vector2) -> void:
	direction = p_direction
	rotation = p_direction.angle()
	%CPUParticles2D.angle_max = -rad_to_deg(rotation)
	%CPUParticles2D.angle_min = -rad_to_deg(rotation)
	%CPUParticles2D.gravity = p_direction * speed / 8
	global_position = player.global_position

func _on_die_timer_timeout() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.take_damage(damage)
		queue_free()
	elif body.name == "TileMapLayer" :
		queue_free()
