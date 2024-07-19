extends Node2D

const BRIGHTNESS = preload("res://Scenes/Shadows/brightness.tscn")

var brightness_layer
var current_level

func _ready() -> void:
	current_level = get_tree().get_first_node_in_group("Level")
	brightness_layer = BRIGHTNESS.instantiate()
	current_level.add_child(brightness_layer)