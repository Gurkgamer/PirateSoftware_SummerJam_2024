extends Control

## ALCHEMY MENU ##

signal gaunlet_alchemy_applied(setting : Vector3, gaunlet_position: int)
signal alchemy_set_active_gaunlet(active_gaunlet_tab : int)

@onready var formula_notebook_button: TextureButton = %FormulaNotebookButton
@onready var formula_notebook: ColorRect = %FormulaNotebook
var is_alchemy_menu_open : bool

func enable_ingredient(name : String) -> void:
	if available_ingredients.has(name.to_lower()):
		available_ingredients[name.to_lower()] = true
		refresh_item_availability()
		
var available_ingredients = {
	"water" : false,
	"vinegar" : false,
	"oil" : true,
	"alcohol" : true,
	"bone" : false,
	"leaf" : false,
	"wood" : true,
	"leather" : false, #stone
	"ruby" : true,
	"topaz" : false,
	"emerald" : false,
	"gold" : false,
	"shadow" : false,
}

func refresh_item_availability() -> void:
	%WaterTexture.disabled = !available_ingredients["water"]
	%VinegarTexture.disabled = !available_ingredients["vinegar"]
	%OilTexture.disabled = !available_ingredients["oil"]
	%AlcoholTexture.disabled = !available_ingredients["alcohol"]
	%BoneTexture.disabled = !available_ingredients["bone"]
	%LeafTexture.disabled = !available_ingredients["leaf"]
	%WoodTexture.disabled = !available_ingredients["wood"]
	%LeatherTexture.disabled = !available_ingredients["leather"]
	%RubyTexture.disabled = !available_ingredients["ruby"]
	%TopazTexture.disabled = !available_ingredients["topaz"]
	%EmeraldTexture.disabled = !available_ingredients["emerald"]
	%GoldTexture.disabled = !available_ingredients["gold"]
	%ShadowTexture.disabled = !available_ingredients["shadow"]
	
enum liquids{
	WATER,
	VINEGAR,
	OIL,
	ALCOHOL
}

enum materials{
	BONE,
	LEAF,
	WOOD,
	LEATHER
}

enum catalysts{
	RUBY,
	TOPAZ,
	EMERALD,
	GOLD,
	SHADOW
}

var current_gaunlet_tab : int
var active_gaunlet_value : int # To keep track inside the menu when changing tabs
var current_liquid : liquids
var current_material : materials
var current_catalyst : catalysts

func _ready() -> void:
	formula_notebook.return_from_notebook_entries.connect(_on_return_from_notebook_entries)
	formula_notebook.global_position.x = get_viewport().get_visible_rect().size.x
	refresh_item_availability()

func _process(_delta: float) -> void:	
	%FormulaNotebookButton.disabled = false if is_alchemy_menu_open else true
	

func set_gaunlet_setups(gaunlets : PackedVector3Array, current_gaunlet : int) -> void:
	for next_gaunlet_position in range(gaunlets.size()):
		var next_gaunlet = gaunlets[next_gaunlet_position]
		_on_tab_container_tab_changed(next_gaunlet_position) # Trick the menu that we are changing tabs to be able to set the receiving setup
		assign_current_formula_to_gaunlet(next_gaunlet)
	_on_tab_container_tab_changed(current_gaunlet)
	current_gaunlet_tab = current_gaunlet
	active_gaunlet_value = current_gaunlet
	%TabContainer.current_tab = current_gaunlet_tab
	
## Funcion que recibira la señal del componente del contenedor de la entrada de formula del notebook
#TODO -> CUando se haya generado el código para agregar una entrada al notebook, que la suscription llame a este metodo
# EL nombre de la señal es "assign_notebook_formula"
func on_notebook_asign_formula(formula_vector : Vector3) -> void:
	assign_current_formula_to_gaunlet(formula_vector)
	_on_clapchemy_button_pressed()
	
func assign_current_formula_to_gaunlet(formula_vector: Vector3) -> void:
	if formula_vector == Vector3(-1,-1,-1):
		formula_vector = Vector3(0,0,0)
	set_liquid_button(formula_vector.x)
	set_material_button(formula_vector.y)
	set_catalyst_button(formula_vector.z)
	current_tab_gaunlet_spell_name.text = get_spell_name_by_vector3(formula_vector)
	
func get_spell_name_by_vector3(formula_combination : Vector3) -> String:
	var spell_name_value : String
	var spell_entry = GameManager.spell_library[formula_combination]
	if spell_entry is String:
		spell_name_value = "Unassigned" #FIXME Esto es poo, hacer que este valor sea una constante y concatenar numeros si realmente se quiere tener tambien el valor de la conbinacion en el nombre
	else:
		spell_name_value = spell_entry["name"]
	return spell_name_value
	
const ACTIVE = preload("res://Scenes/CanvasLayers/AlchemyMenu/Images/active.png")
const NOT_ACTIVE = preload("res://Scenes/CanvasLayers/AlchemyMenu/Images/not_active.png")

func _on_active_gaunlet_button_pressed() -> void:
	alchemy_set_active_gaunlet.emit(current_gaunlet_tab)
	active_gaunlet_value = current_gaunlet_tab
	set_active_gaunlet_check()

func set_active_gaunlet_check() -> void:
	%ActiveTexture.texture = ACTIVE
	%ActiveLabel.text = "ACTIVE"

func set_inactive_gaunlet_check() -> void:
	%ActiveTexture.texture = NOT_ACTIVE
	%ActiveLabel.text = "NOT ACTIVE"
	
## BOTON MAGICO
func _on_clapchemy_button_pressed() -> void:
	var formula_combination = Vector3(current_liquid, current_material, current_catalyst)
	var spell_name_obtained = get_spell_name_by_vector3(formula_combination)
	if spell_name_obtained.contains("Unassigned"):
		#TODO -> Lanzar mensaje de que no hay formula para esa combinación
		#SUGGESTION -> Hacer que el jugador pierda la magia en este guante o que lo mantenga?
		var mantener : bool = false
		if mantener :
			return #Mantener magia
		else :
			spell_name_obtained = "Nothing"
			var original_formula_combination = formula_combination
			formula_combination = Vector3(-1,-1,-1)
			GameManager.update_player_layer_spell_data(formula_combination, current_gaunlet_tab)
			GameManager.available_gaunlets[current_gaunlet_tab] = formula_combination
			formula_combination = original_formula_combination
	current_tab_gaunlet_spell_name.text = spell_name_obtained
	gaunlet_alchemy_applied.emit(formula_combination, current_gaunlet_tab)
	var is_new_spell = formula_notebook.add_notebook_entry(formula_combination)
	if is_new_spell :
		is_new_spell.assign_notebook_formula.connect(on_notebook_asign_formula)
		# TODO -> Hacer fanfare cuando se consiga una magia nueva
		
	
func _on_tab_container_tab_changed(tab: int) -> void:
	current_gaunlet_tab = tab
	match tab:
		0:
			potion = %Potion0
			gaunlet_left = %GaunletLeft0
			gaunlet_right = %GaunletRight0
			current_tab_gaunlet_spell_name = %AssignedSpellName0
		1: 
			potion = %Potion1
			gaunlet_left = %GaunletLeft1
			gaunlet_right = %GaunletRight1
			current_tab_gaunlet_spell_name = %AssignedSpellName1
		2:
			potion = %Potion2
			gaunlet_left = %GaunletLeft2
			gaunlet_right = %GaunletRight2
			current_tab_gaunlet_spell_name = %AssignedSpellName2
		3:
			potion = %Potion3
			gaunlet_left = %GaunletLeft3
			gaunlet_right = %GaunletRight3
			current_tab_gaunlet_spell_name = %AssignedSpellName3
			
	if active_gaunlet_value != tab :
		set_inactive_gaunlet_check()
	else :
		set_active_gaunlet_check()

## GAUNLETS

var current_tab_gaunlet_spell_name : Label

#region LIQUIDS

## LUQUID BUTTONS

@onready var potion: TextureRect

const POTION_WATER = preload("res://Scenes/CanvasLayers/AlchemyMenu/Images/potion_water.png")
const POTION_VINEGAR = preload("res://Scenes/CanvasLayers/AlchemyMenu/Images/potion_vinegar.png")
const POTION_OIL = preload("res://Scenes/CanvasLayers/AlchemyMenu/Images/potion_oil.png")
const POTION_ALCOHOL = preload("res://Scenes/CanvasLayers/AlchemyMenu/Images/potion_alcohol.png")

## Sets the liquid material received as the pressed one
# Being the buttons in a group, just setting the correct one will unpress the others
func set_liquid_button(value : int) -> void :
	match value:
		liquids.WATER :
			_on_water_texture_toggled(true)
		liquids.VINEGAR :
			_on_vinegar_texture_toggled(true)
		liquids.OIL :
			_on_oil_texture_toggled(true)
		liquids.ALCOHOL:
			_on_alcohol_texture_toggled(true)
	
func _on_water_texture_toggled(toggled_on: bool) -> void:
	if toggled_on:
		current_liquid = liquids.WATER
		potion.texture = POTION_WATER

func _on_vinegar_texture_toggled(toggled_on: bool) -> void:
	if toggled_on:
		current_liquid = liquids.VINEGAR
		potion.texture = POTION_VINEGAR

func _on_oil_texture_toggled(toggled_on: bool) -> void:
	if toggled_on:
		current_liquid = liquids.OIL
		potion.texture = POTION_OIL

func _on_alcohol_texture_toggled(toggled_on: bool) -> void:
	if toggled_on:
		current_liquid = liquids.ALCOHOL
		potion.texture = POTION_ALCOHOL

#endregion

#region MATERIAL

## MATERIAL BUTTONS

@onready var gaunlet_left: TextureRect

const GAUNLET_BONE = preload("res://Scenes/CanvasLayers/AlchemyMenu/Images/gaunlet_bone.png")
const GAUNLET_LEAF = preload("res://Scenes/CanvasLayers/AlchemyMenu/Images/gaunlet_leaf.png")
const GAUNLET_WOOD = preload("res://Scenes/CanvasLayers/AlchemyMenu/Images/gaunlet_wood.png")
const GAUNLET_LEATHER = preload("res://Scenes/CanvasLayers/AlchemyMenu/Images/gaunlet_leather.png")

func set_material_button(value : int) -> void :
	match value:
		materials.BONE :
			_on_bone_texture_toggled(true)
		materials.LEAF :
			_on_leaf_texture_toggled(true)
		materials.WOOD :
			_on_wood_texture_toggled(true)
		materials.LEATHER:
			_on_leather_texture_toggled(true)

func _on_bone_texture_toggled(toggled_on: bool) -> void:
	if toggled_on :
		current_material = materials.BONE
		gaunlet_left.texture = GAUNLET_BONE

func _on_leaf_texture_toggled(toggled_on: bool) -> void:
	if toggled_on :
		current_material = materials.LEAF
		gaunlet_left.texture = GAUNLET_LEAF
		
func _on_wood_texture_toggled(toggled_on: bool) -> void:
	if toggled_on :
		gaunlet_left.texture = GAUNLET_WOOD
		current_material = materials.WOOD

func _on_leather_texture_toggled(toggled_on: bool) -> void:
	if toggled_on :
		current_material = materials.LEATHER
		gaunlet_left.texture = GAUNLET_LEATHER

#endregion

#region CATALYST

## CATALYST BUTTONS

@onready var gaunlet_right: TextureRect

const GAUNLET_RUBY = preload("res://Scenes/CanvasLayers/AlchemyMenu/Images/gaunlet_ruby.png")
const GAUNLET_TOPAZ = preload("res://Scenes/CanvasLayers/AlchemyMenu/Images/gaunlet_topaz.png")
const GAUNLET_EMERALD = preload("res://Scenes/CanvasLayers/AlchemyMenu/Images/gaunlet_emerald.png")
const GAUNLET_GOLD = preload("res://Scenes/CanvasLayers/AlchemyMenu/Images/gaunlet_gold.png")
const GAUNLET_SHADOW = preload("res://Scenes/CanvasLayers/AlchemyMenu/Images/gaunlet_shadow.png")

func set_catalyst_button(value : int) -> void :
	match value:
		catalysts.RUBY :
			_on_ruby_texture_toggled(true)
		catalysts.TOPAZ :
			_on_topaz_texture_toggled(true)
		catalysts.EMERALD :
			_on_emerald_texture_toggled(true)
		catalysts.GOLD:
			_on_gold_texture_toggled(true)
		catalysts.SHADOW:
			_on_shadow_texture_toggled(true)

func _on_ruby_texture_toggled(toggled_on: bool) -> void:
	if toggled_on :
		current_catalyst = catalysts.RUBY
		gaunlet_right.texture = GAUNLET_RUBY

func _on_topaz_texture_toggled(toggled_on: bool) -> void:
	if toggled_on :
		current_catalyst = catalysts.TOPAZ
		gaunlet_right.texture = GAUNLET_TOPAZ

func _on_emerald_texture_toggled(toggled_on: bool) -> void:
	if toggled_on :
		current_catalyst = catalysts.EMERALD
		gaunlet_right.texture = GAUNLET_EMERALD

func _on_gold_texture_toggled(toggled_on: bool) -> void:
	if toggled_on :
		current_catalyst = catalysts.GOLD
		gaunlet_right.texture = GAUNLET_GOLD

func _on_shadow_texture_toggled(toggled_on: bool) -> void:
	if toggled_on :
		current_catalyst = catalysts.SHADOW
		gaunlet_right.texture = GAUNLET_SHADOW

#endregion

## NOTEBOOK ENTRY LAYER

func _on_texture_button_pressed() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	var tween = create_tween()
	tween.tween_property(formula_notebook, "global_position:x", viewport_size.x / 2 ,0.1)

func _on_return_from_notebook_entries():
	var viewport_size = get_viewport().get_visible_rect().size
	var tween = create_tween()
	tween.tween_property(formula_notebook, "global_position:x", viewport_size.x, 0.1)
	return tween
