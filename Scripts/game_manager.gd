extends Node

var in_menu : bool = true
var mouse_ingame_cursor = preload("res://Images/UI/pointer.png")
const ALCHEMY_MENU_SCENE = preload("res://Scenes/CanvasLayers/AlchemyMenu/alchemy_menu.tscn")
const PLAYER_STATUS = preload("res://Scenes/CanvasLayers/PlayerStatus/player_status.tscn")
var current_level

var player : CharacterBody2D

var active_gaunlet : int = 0:
	get:
		return active_gaunlet
	set (value):
		if value >= available_gaunlets.size():
			active_gaunlet = 0
			return
		if value < 0 :
			active_gaunlet = available_gaunlets.size() - 1
			return
		active_gaunlet = value
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
	player_status_layer.set_player_hearlth(player.health)
	player_status_layer.layer = 2
	for next_spell_position in range(available_gaunlets.size()-1,-1,-1):
		update_player_layer_spell_data(available_gaunlets[next_spell_position],next_spell_position)
	get_tree().root.add_child.call_deferred(player_status_layer)
	active_gaunlet = 0
	player_status_layer.set_active_spell(active_gaunlet)
	#TODO -> Añadir escena invalida como primera magia?????
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if in_menu :
		Input.set_custom_mouse_cursor(mouse_ingame_cursor,Input.CURSOR_ARROW,Vector2(0,0))
	else :
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("OpenAlchemyMenu"):
		if !canvas_alchemy_layer :
			open_alchemy_menu()
		else :
			close_alchemy_menu()
			
func _on_player_gaunlet_change(direction : bool) -> void :
	if direction:
		active_gaunlet +=1
	else :
		active_gaunlet -=1
	_on_alchemy_set_active_gaunlet(active_gaunlet)

func on_player_health_change(health_value : int) -> void:
	pass
	
func open_alchemy_menu() -> void:
	get_tree().paused = true
	#TODO - Comprobobar que esta en un nivel y no en otro lado [No abrir si no es durante el juego]
	canvas_alchemy_layer = CanvasLayer.new()
	canvas_alchemy_layer.layer = 3
	alchemy_menu = ALCHEMY_MENU_SCENE.instantiate()
	var viewport_size = get_viewport().get_visible_rect().size
	alchemy_menu.global_position.x = viewport_size.x
	canvas_alchemy_layer.add_child(alchemy_menu)
	get_tree().root.add_child(canvas_alchemy_layer)
	alchemy_menu.set_gaunlet_setups(available_gaunlets, active_gaunlet)
	alchemy_menu.gaunlet_alchemy_applied.connect(_on_alchemy_setting_set)
	alchemy_menu.alchemy_set_active_gaunlet.connect(_on_alchemy_set_active_gaunlet)
	var tween = create_tween()
	tween.tween_property(alchemy_menu, "position:x", 0,0.1)
	
func close_alchemy_menu() -> void:
	var tween = create_tween()
	var viewport_size = get_viewport().get_visible_rect().size
	tween.tween_property(alchemy_menu, "position:x", viewport_size.x, 0.1).finished.connect(func() -> void: 
		canvas_alchemy_layer.queue_free()
		get_tree().paused = false
		, CONNECT_ONE_SHOT)

func _on_alchemy_set_active_gaunlet(gaunlet_position: int) -> void:
	active_gaunlet = gaunlet_position
	update_player_layer_spell_data(available_gaunlets[active_gaunlet], active_gaunlet)
	player_status_layer.set_active_spell(gaunlet_position)
	var diccionaro = available_gaunlets[active_gaunlet]
	var spell_data = spell_library[diccionaro]
	if !spell_data is String:
		spell_data = spell_library[Vector3(-1,-1,-1)]
	player.set_spell(spell_library[diccionaro]["scene"])

func _on_alchemy_setting_set(new_gaunlet_setting : Vector3, gaunlet_position: int) -> void :
	update_player_layer_spell_data(new_gaunlet_setting, gaunlet_position)
	if gaunlet_position == active_gaunlet: # Si es el guante activo, actualizar directamente la escena del jugador para la magia
		_on_alchemy_set_active_gaunlet(gaunlet_position)

## ESTO SOLO ACTUALIZA LA INFORMACION DE LAS MAGIAS EN PANTALLA DEL PLAYER LAYER
func update_player_layer_spell_data(new_setting : Vector3, gaunlet_position : int) -> void :
	available_gaunlets[gaunlet_position] = new_setting
	var spell_packedscene = spell_library[new_setting]
	if !spell_packedscene is String:
		player_status_layer.set_gaunlet_data(spell_packedscene["name"], spell_packedscene["icon"], gaunlet_position)
	else : #CHORE - Quitar esto al acabar
		print("NO HAY PARA ESTA COMBINACION")
	
# LIQUID - SOLID - CATALYST
var spell_library ={
	# TODO - Poner escena para invalido aqui
	Vector3(-1,-1,-1): {"name":"Nothing","scene": null, "icon": preload("res://Scenes/AlchemySpells/Invalid/Images/invalid_icon.png")},
	# X-X-0 -> Ruby
	Vector3(0,0,0): "Resource000",
	Vector3(1,0,0): "Resource100",
	Vector3(2,0,0): "Resource200",
	Vector3(3,0,0): "Resource300",
	Vector3(0,1,0): "Resource010",
	Vector3(1,1,0): "Resource110",
	Vector3(2,1,0): "Resource210",
	Vector3(3,1,0): "Resource310",
	Vector3(0,2,0): "Resource020", # Vapor - FieldSkill - Steam like puzzles?
	Vector3(1,2,0): "Resource120", # FireShield - Defensive - Fire attack protection
	Vector3(2,2,0): {"name": "Bonfire", "scene" : preload("res://Scenes/AlchemySpells/BonFire/bonfire.tscn"), "icon" : preload("res://Scenes/AlchemySpells/BonFire/Images/bonfire_icon.png")}, # FieldSkill - Increases level brigthness
	Vector3(3,2,0): {"name": "Fireball", "scene" : preload("res://Scenes/AlchemySpells/FireBall/fire_ball.tscn"), "icon" : preload("res://Scenes/AlchemySpells/FireBall/Images/fireball_icon.png")}, # Offensive
	Vector3(0,3,0): "Resource030",
	Vector3(1,3,0): "Resource130",
	Vector3(2,3,0): "Resource230",
	Vector3(3,3,0): "Resource330",
	# X-X-1 -> Topaz
	Vector3(0,0,1): "Resource001",
	Vector3(1,0,1): "Resource101",
	Vector3(2,0,1): "Resource201",
	Vector3(3,0,1): "Resource301",
	Vector3(0,1,1): "Resource011",
	Vector3(1,1,1): "Resource111",
	Vector3(2,1,1): "Resource211",
	Vector3(3,1,1): "Resource311",
	Vector3(0,2,1): "Resource021",
	Vector3(1,2,1): "Resource121",
	Vector3(2,2,1): "Resource221",
	Vector3(3,2,1): "Resource321",
	Vector3(0,3,1): "Resource031",
	Vector3(1,3,1): "Resource131",
	Vector3(2,3,1): "Resource231",
	Vector3(3,3,1): "Resource331",
	# 2-X-X -> EMERALD
	Vector3(0,0,2): "Resource002",
	Vector3(1,0,2): "Resource102",
	Vector3(2,0,2): "Resource202",
	Vector3(3,0,2): "Resource302",
	Vector3(0,1,2): "Resource012",
	Vector3(1,1,2): "Resource112",
	Vector3(2,1,2): "Resource212",
	Vector3(3,1,2): "Resource312",
	Vector3(0,2,2): "Resource022",
	Vector3(1,2,2): "Resource122",
	Vector3(2,2,2): "Resource222",
	Vector3(3,2,2): "Resource322",
	Vector3(0,3,2): "Resource032",
	Vector3(1,3,2): "Resource132",
	Vector3(2,3,2): "Resource232",
	Vector3(3,3,2): "Resource332",
	# 2-X-X -> GOLD
	Vector3(0,0,3): "Resource003",
	Vector3(1,0,3): "Resource103",
	Vector3(2,0,3): "Resource203",
	Vector3(3,0,3): "Resource303",
	Vector3(0,1,3): "Resource013",
	Vector3(1,1,3): "Resource113",
	Vector3(2,1,3): "Resource213",
	Vector3(3,1,3): "Resource313",
	Vector3(0,2,3): "Resource023",
	Vector3(1,2,3): "Resource123",
	Vector3(2,2,3): "Resource223",
	Vector3(3,2,3): "Resource323",
	Vector3(0,3,3): "Resource033",
	Vector3(1,3,3): "Resource133",
	Vector3(2,3,3): "Resource233",
	Vector3(3,3,3): "Resource333",
	# 2-X-X -> SHADOW
	Vector3(0,0,4): "Resource004",
	Vector3(1,0,4): "Resource104",
	Vector3(2,0,4): "Resource204",
	Vector3(3,0,4): "Resource304",
	Vector3(0,1,4): "Resource014",
	Vector3(1,1,4): "Resource114",
	Vector3(2,1,4): "Resource214",
	Vector3(3,1,4): "Resource314",
	Vector3(0,2,4): "Resource024",
	Vector3(1,2,4): "Resource124",
	Vector3(2,2,4): "Resource224",
	Vector3(3,2,4): "Resource324",
	Vector3(0,3,4): "Resource034",
	Vector3(1,3,4): "Resource134",
	Vector3(2,3,4): "Resource234",
	Vector3(3,3,4): "Resource334"
}
