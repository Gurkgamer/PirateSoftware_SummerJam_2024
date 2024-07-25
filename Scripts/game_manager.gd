extends Node

var in_menu : bool = true
var mouse_ingame_cursor = preload("res://Images/UI/pointer.png")
const ALCHEMY_MENU_SCENE = preload("res://Scenes/CanvasLayers/AlchemyMenu/alchemy_menu.tscn")
const PLAYER_STATUS = preload("res://Scenes/CanvasLayers/PlayerStatus/player_status.tscn")
var current_level

var player : CharacterBody2D

var active_gaunlet_slot : int = 0:
	get:
		return active_gaunlet_slot
	set (value):
		if value >= available_gaunlets.size():
			active_gaunlet_slot = 0
			return
		if value < 0 :
			active_gaunlet_slot = available_gaunlets.size() - 1
			return
		active_gaunlet_slot = value
var available_gaunlets : PackedVector3Array = [
	Vector3(-1,-1,-1),
	Vector3(-1,-1,-1),
	Vector3(-1,-1,-1),
	Vector3(-1,-1,-1)]
var canvas_alchemy_layer : CanvasLayer
var player_status_layer
var alchemy_menu : Control

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	player = get_tree().get_first_node_in_group("Player")
	player.gaunlet_changed.connect(_on_player_gaunlet_change)
	player.health_change.connect(on_player_health_change)
	#TODO -> Mejor momento para añadir el layer de status?
	player_status_layer = PLAYER_STATUS.instantiate()
	player_status_layer.set_player_health(player.health)
	player_status_layer.layer = 2
	for next_spell_position in range(available_gaunlets.size()-1,-1,-1):
		update_player_layer_spell_data(available_gaunlets[next_spell_position],next_spell_position)
		_on_alchemy_setting_set(available_gaunlets[next_spell_position],next_spell_position)
	get_tree().root.add_child.call_deferred(player_status_layer)
	active_gaunlet_slot = 0
	player_status_layer.set_active_spell(active_gaunlet_slot)
	available_gaunlets = [
	Vector3(0,0,0),
	Vector3(0,0,0),
	Vector3(0,0,0),
	Vector3(0,0,0)]
	
func _process(_delta: float) -> void:
	
	if in_menu :
		Input.set_custom_mouse_cursor(mouse_ingame_cursor,Input.CURSOR_ARROW,Vector2(0,0))
	else :
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("OpenAlchemyMenu"):
		if !alchemy_menu or !alchemy_menu.is_alchemy_menu_open :
			open_alchemy_menu()
		else :
			close_alchemy_menu()
			
func _on_player_gaunlet_change(direction : bool) -> void :
	if direction:
		active_gaunlet_slot +=1
	else :
		active_gaunlet_slot -=1
	_on_alchemy_set_active_gaunlet(active_gaunlet_slot)

func on_player_health_change(health_value : int) -> void:
	player_status_layer.set_player_health(health_value)
	
func open_alchemy_menu() -> void:
	get_tree().paused = true
	#TODO - Comprobobar que esta en un nivel y no en otro lado [No abrir si no es durante el juego]
	if !canvas_alchemy_layer:
		canvas_alchemy_layer = CanvasLayer.new()
		canvas_alchemy_layer.layer = 3
		alchemy_menu = ALCHEMY_MENU_SCENE.instantiate()
		var viewport_size = get_viewport().get_visible_rect().size
		alchemy_menu.global_position.x = viewport_size.x
		canvas_alchemy_layer.add_child(alchemy_menu)
		get_tree().root.add_child(canvas_alchemy_layer)
	
		alchemy_menu.gaunlet_alchemy_applied.connect(_on_alchemy_setting_set)
		alchemy_menu.alchemy_set_active_gaunlet.connect(_on_alchemy_set_active_gaunlet)
	
	alchemy_menu.set_gaunlet_setups(available_gaunlets, active_gaunlet_slot)
	var tween = create_tween()
	tween.tween_property(alchemy_menu, "position:x", 0,0.1).finished.connect(func() -> void: 
		alchemy_menu.is_alchemy_menu_open = true
		)
	
func close_alchemy_menu() -> void:
	alchemy_menu.is_alchemy_menu_open = false
	var submenu_tween : Tween = alchemy_menu._on_return_from_notebook_entries()
	submenu_tween.finished.connect(func() -> void:
		var tween = create_tween()
		var viewport_size = get_viewport().get_visible_rect().size
		tween.tween_property(alchemy_menu, "position:x", viewport_size.x, 0.1).finished.connect(func() -> void: 
			get_tree().paused = false
			alchemy_menu.is_alchemy_menu_open = false
			, CONNECT_ONE_SHOT)
			, CONNECT_ONE_SHOT)

func _on_alchemy_set_active_gaunlet(gaunlet_slot: int) -> void:
	active_gaunlet_slot = gaunlet_slot
	update_player_layer_spell_data(available_gaunlets[gaunlet_slot], gaunlet_slot)
	player_status_layer.set_active_spell(gaunlet_slot)
	var active_apell_combination = available_gaunlets[gaunlet_slot]
	var spell_data = spell_library[active_apell_combination]
	if spell_data is String:
		spell_data = spell_library[Vector3(-1,-1,-1)]
	#player.set_spell(spell_library[active_apell_combination]["scene"])
	player.set_spell(spell_data["scene"])

## AL PULSAR EL BOTON MAGICO
func _on_alchemy_setting_set(new_gaunlet_setting : Vector3, gaunlet_slot: int) -> void :
	update_player_layer_spell_data(new_gaunlet_setting, gaunlet_slot)
	if gaunlet_slot == active_gaunlet_slot: # Si es el guante activo, actualizar directamente la escena del jugador para la magia
		_on_alchemy_set_active_gaunlet(gaunlet_slot)

## ESTO SOLO ACTUALIZA LA INFORMACION DE LAS MAGIAS EN PANTALLA DEL PLAYER LAYER
func update_player_layer_spell_data(new_setting : Vector3, gaunlet_slot : int) -> void :
	available_gaunlets[gaunlet_slot] = new_setting
	var spell_packedscene = spell_library[new_setting]
	if !spell_packedscene is String:
		player_status_layer.set_gaunlet_data(spell_packedscene["name"], spell_packedscene["icon"], gaunlet_slot)
	else : #CHORE - Quitar esto al acabar
		print("NO HAY PARA ESTA COMBINACION " + str(new_setting))
	
# LIQUID - SOLID - CATALYST
var spell_library ={
	# HACK - Todo esto deberian ser recursos fisicos en el proyecto
	Vector3(-1,-1,-1): {"name":"Nothing","scene": preload("res://Scenes/AlchemySpells/Nothing/nothing.tscn"), "icon": preload("res://Scenes/AlchemySpells/Nothing/Images/nothing_icon.png")},
	# X-X-0 -> Ruby
	Vector3(0,0,0): "Unassigned000",
	Vector3(1,0,0): "Unassigned100",
	Vector3(2,0,0): "Unassigned200",
	Vector3(3,0,0): "Unassigned300",
	Vector3(0,1,0): "Unassigned010",
	Vector3(1,1,0): "Unassigned110",
	Vector3(2,1,0): "Unassigned210", # Arbol que cura
	Vector3(3,1,0): {"name": "Ivystream", "scene":preload("res://Scenes/AlchemySpells/Ivystream/ivystream.tscn"), "icon": preload("res://Scenes/AlchemySpells/Ivystream/Images/ivystream_icon.png")},
	Vector3(0,2,0): "Unassigned020", # Vapor - FieldSkill - Steam like puzzles?
	Vector3(1,2,0): {"name":"Fireshield", "scene":preload("res://Scenes/AlchemySpells/Fireshield/fireshield.tscn"), "icon":preload("res://Scenes/AlchemySpells/Fireshield/Images/fireshield_icon.png")}, # FireShield - Defensive - Fire attack protection
	Vector3(2,2,0): {"name": "Bonfire", "scene" : preload("res://Scenes/AlchemySpells/BonFire/bonfire.tscn"), "icon" : preload("res://Scenes/AlchemySpells/BonFire/Images/bonfire_icon.png")}, # FieldSkill - Increases level brigthness
	Vector3(3,2,0): {"name": "Fireball", "scene" : preload("res://Scenes/AlchemySpells/FireBall/fire_ball.tscn"), "icon" : preload("res://Scenes/AlchemySpells/FireBall/Images/fireball_icon.png")}, # Offensive
	Vector3(0,3,0): "Unassigned030",
	Vector3(1,3,0): "Unassigned130",
	Vector3(2,3,0): "Unassigned230",
	Vector3(3,3,0): "Unassigned330",
	# X-X-1 -> Topaz
	Vector3(0,0,1): "Unassigned001",
	Vector3(1,0,1): "Unassigned101",
	Vector3(2,0,1): "Unassigned201",
	Vector3(3,0,1): "Unassigned301",
	Vector3(0,1,1): "Unassigned011",
	Vector3(1,1,1): "Unassigned111",
	Vector3(2,1,1): "Unassigned211",
	Vector3(3,1,1): "Unassigned311",
	Vector3(0,2,1): "Unassigned021",
	Vector3(1,2,1): "Unassigned121",
	Vector3(2,2,1): "Unassigned221",
	Vector3(3,2,1): "Unassigned321",
	Vector3(0,3,1): "Unassigned031",
	Vector3(1,3,1): "Unassigned131",
	Vector3(2,3,1): "Unassigned231",
	Vector3(3,3,1): "Unassigned331",
	# 2-X-X -> EMERALD
	Vector3(0,0,2): "Unassigned002",
	Vector3(1,0,2): "Unassigned102",
	Vector3(2,0,2): "Unassigned202",
	Vector3(3,0,2): "Unassigned302",
	Vector3(0,1,2): "Unassigned012",
	Vector3(1,1,2): "Unassigned112",
	Vector3(2,1,2): "Unassigned212",
	Vector3(3,1,2): "Unassigned312",
	Vector3(0,2,2): "Unassigned022",
	Vector3(1,2,2): "Unassigned122",
	Vector3(2,2,2): "Unassigned222",
	Vector3(3,2,2): "Unassigned322",
	Vector3(0,3,2): "Unassigned032",
	Vector3(1,3,2): "Unassigned132",
	Vector3(2,3,2): "Unassigned232",
	Vector3(3,3,2): "Unassigned332",
	# 2-X-X -> GOLD
	Vector3(0,0,3): "Unassigned003",
	Vector3(1,0,3): "Unassigned103",
	Vector3(2,0,3): "Unassigned203",
	Vector3(3,0,3): "Unassigned303",
	Vector3(0,1,3): "Unassigned013",
	Vector3(1,1,3): "Unassigned113",
	Vector3(2,1,3): "Unassigned213",
	Vector3(3,1,3): "Unassigned313",
	Vector3(0,2,3): "Unassigned023",
	Vector3(1,2,3): "Unassigned123",
	Vector3(2,2,3): "Unassigned223",
	Vector3(3,2,3): "Unassigned323",
	Vector3(0,3,3): "Unassigned033",
	Vector3(1,3,3): "Unassigned133",
	Vector3(2,3,3): "Unassigned233",
	Vector3(3,3,3): "Unassigned333",
	# 2-X-X -> SHADOW
	Vector3(0,0,4): "Unassigned004",
	Vector3(1,0,4): "Unassigned104",
	Vector3(2,0,4): "Unassigned204",
	Vector3(3,0,4): "Unassigned304",
	Vector3(0,1,4): "Unassigned014",
	Vector3(1,1,4): "Unassigned114",
	Vector3(2,1,4): "Unassigned214",
	Vector3(3,1,4): "Unassigned314",
	Vector3(0,2,4): "Unassigned024",
	Vector3(1,2,4): "Unassigned124",
	Vector3(2,2,4): "Unassigned224",
	Vector3(3,2,4): "Unassigned324",
	Vector3(0,3,4): "Unassigned034",
	Vector3(1,3,4): "Unassigned134",
	Vector3(2,3,4): "Unassigned234",
	Vector3(3,3,4): "Unassigned334"
}

func enable_ingredient(name : String)->void:
	alchemy_menu.enable_ingredient(name)
	
func show_new_item_notification(what : String) -> void:
	player_status_layer.show_notification(what)
