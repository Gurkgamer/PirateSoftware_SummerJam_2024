extends Node2D

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D
@onready var sprite_2d: Sprite2D = %Sprite2D

var is_inside_screen : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(is_inside_screen)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_inside_screen = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_inside_screen = false
