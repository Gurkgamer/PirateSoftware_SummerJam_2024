extends Node2D

const BRIGHTNESS = preload("res://Scenes/CanvasLayers/Brightness/brightness.tscn")
var brightness_layer
var current_level

func _ready() -> void:
	current_level = get_tree().get_first_node_in_group("Level")
	brightness_layer = BRIGHTNESS.instantiate()
	current_level.add_child(brightness_layer)

func get_brigthness() -> float :
	return brightness_layer.get_brightness()

func fade_to_black() -> void:
	brightness_layer.fade_to_black()
