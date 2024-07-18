extends Node2D

var direction : Vector2
var speed : float = 2000.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += delta * direction * speed

func set_direction(p_direction : Vector2) -> void:
	direction = p_direction
	rotation = p_direction.angle()
