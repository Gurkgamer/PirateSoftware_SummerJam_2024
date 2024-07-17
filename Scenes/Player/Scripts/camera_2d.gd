extends Camera2D

var positioning_speed : float = 0.2
var smooth_movement_speed : float = 10.0

func _process(delta : float) -> void :
	
	var mouse_position = get_global_mouse_position()
	
	var direction_to_mouse = (mouse_position - position).normalized()
	var distance_to_mouse = mouse_position.distance_to(global_position)
	var camera_destination = direction_to_mouse * distance_to_mouse * positioning_speed
	
	offset = lerp(offset, camera_destination, delta * smooth_movement_speed)
