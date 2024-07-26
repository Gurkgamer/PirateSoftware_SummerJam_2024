extends Node2D

var player
var cooldown = 12
@onready var healing_timer: Timer = %HealingTimer

func _ready()->void:
	%DieTimer.start()

func initialize(p_player : CharacterBody2D, mouse_direction : Vector2):
	global_position = p_player.global_position
	player = p_player

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and %HealingTimer.is_stopped():
		%HealingTimer.start()
		
func _on_healing_timer_timeout() -> void:
	player.take_health(10)

func _on_die_timer_timeout() -> void:
	%HealingTimer.stop()
	queue_free()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if healing_timer:
		healing_timer.stop()
