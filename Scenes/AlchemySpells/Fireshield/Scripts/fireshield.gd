extends Node2D

var player : CharacterBody2D
const FIRESHIELDFLARE = preload("res://Scenes/AlchemySpells/Fireshield/fireshieldflare.tscn")
var cooldown = 23

func _ready() -> void:
	%DieTimer.start()

func _process(delta: float) -> void:
	global_position = player.global_position

func initialize(p_player : CharacterBody2D, mouse_direction : Vector2) -> void:
	player = p_player
	for next_flare in range(4):
		var new_flare = FIRESHIELDFLARE.instantiate()
		new_flare.initialize(player, next_flare * 90)
		add_child(new_flare)
	player.set_shield(true)
	
func _on_die_timer_timeout() -> void:
	player.set_shield(false)
	queue_free()
