extends Node2D

var damage : int
var damage_target :CharacterBody2D

func set_values(damage_value : int, target : CharacterBody2D) -> void:
	damage = damage_value
	damage_target = target

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == damage_target :
		damage_target.take_damage(damage, self)

func _on_die_timer_timeout() -> void:
	queue_free()
