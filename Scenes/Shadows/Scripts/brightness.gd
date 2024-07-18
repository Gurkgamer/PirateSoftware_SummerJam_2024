extends CanvasLayer

var number_bonfires : float
var number_shadows : float

func _process(_delta: float) -> void:
	var brightness : float
	
	number_bonfires = get_tree().get_nodes_in_group("BonFire").size()
	number_shadows = get_tree().get_nodes_in_group("Shadow").size()
	
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
	
	%TextureRect.modulate.a = brightness
