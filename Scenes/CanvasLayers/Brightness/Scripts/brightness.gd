extends CanvasLayer

var number_bonfires : float
var number_shadows : float
var current_brightness: float
var boss

func _ready() -> void:
	boss = get_tree().get_nodes_in_group("Boss")[0]

func _process(_delta: float) -> void:
	if end : return
	number_shadows = 0
	number_bonfires = get_tree().get_nodes_in_group("BonFire").size()
	var shadows = get_tree().get_nodes_in_group("Shadow")
		
	for next_shadow in shadows:
		if next_shadow.is_inside_screen: #SUGGESTION -> Hacer que las fogatas tambien funcionen solo si estan en pantalla?
			number_shadows += 1
	
	if number_shadows >= 10 :
		number_shadows = 10
	if number_bonfires >= 10:
		number_bonfires = 10
	
	if number_shadows == 0:
		current_brightness = 0
	elif number_bonfires == 0:
		current_brightness = number_shadows / 7.0
	else :
		current_brightness = (number_shadows  - number_bonfires) / 7.0

	if boss.boss_on_screen:
		current_brightness += 0.3 
		
	if boss.boss_on_screen and current_brightness < 0.3:
		current_brightness = 0.3
		
	current_brightness = clamp(current_brightness, 0.0, 1.0)
	var tween = create_tween()
	tween.tween_property(%TextureRect, "modulate:a",current_brightness,0.5)
	
func get_brightness() -> float:
	return current_brightness

var end : bool	= false
const CREDITS = preload("res://Scenes/Credits/credits.tscn")

func fade_to_black():
	end = true
	Engine.time_scale = 0.3
	var tween = create_tween()
	tween.tween_property(%TextureRect, "modulate:a",1,0.5).finished.connect(func()->void:
		get_tree().root.add_child(CREDITS.instantiate())
		)
