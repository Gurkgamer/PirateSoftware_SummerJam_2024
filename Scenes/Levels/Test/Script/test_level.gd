extends Node2D

@onready var canvas_layer: CanvasLayer = %CanvasLayer

func _on_button_pressed() -> void:
	canvas_layer.queue_free()
