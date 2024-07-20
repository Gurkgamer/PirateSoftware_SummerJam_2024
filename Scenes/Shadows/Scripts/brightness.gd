extends CanvasLayer

var number_bonfires : float
var number_shadows : float

func _process(_delta: float) -> void:
	var brightness : float
	number_shadows = 0
	number_bonfires = get_tree().get_nodes_in_group("BonFire").size()
	var shadows = get_tree().get_nodes_in_group("Shadow")
		
	for next_shadow in shadows:
		if next_shadow.is_inside_screen:
			number_shadows += 1
	
	if number_shadows >= 10 :
		number_shadows = 10
	if number_bonfires >= 10:
		number_bonfires = 10
	
	if number_shadows == 0:
		brightness = 0
	elif number_bonfires == 0:
		brightness = number_shadows / 10.0
	else :
		brightness = (number_shadows  - number_bonfires) / 10.0
	var tween = create_tween()
	tween.tween_property(%TextureRect, "modulate:a",brightness,0.5)	
