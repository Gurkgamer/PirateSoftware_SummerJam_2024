extends Node

var mouse_ingame_cursor = preload("res://Images/UI/pointer.png")
var in_menu : bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_menu :
		Input.set_custom_mouse_cursor(mouse_ingame_cursor,Input.CURSOR_ARROW,Vector2(0,0))
	else :
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
