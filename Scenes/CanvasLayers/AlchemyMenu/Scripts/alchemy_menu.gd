extends Control

signal gaunlet_alchemy_applied(setting : Vector3, gaunlet_position: int)
signal alchemy_set_active_gaunlet(active_gaunlet_tab : int)

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

func set_gaunlet_setups(gaunlets : PackedVector3Array, current_gaunlet : int) -> void:
	for next_gaunlet_position in range(gaunlets.size()):
		var next_gaunlet = gaunlets[next_gaunlet_position]
		_on_tab_container_tab_changed(next_gaunlet_position) # Trick the menu that we are changing tabs to be able to set the receiving setup
		set_liquid_button(next_gaunlet.x)
		set_material_button(next_gaunlet.y)
		set_catalyst_button(next_gaunlet.z)
	_on_tab_container_tab_changed(current_gaunlet)
	current_gaunlet_tab = current_gaunlet
	active_gaunlet_value = current_gaunlet
	%TabContainer.current_tab = current_gaunlet_tab
	
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
	
func _on_clapchemy_button_pressed() -> void:
	gaunlet_alchemy_applied.emit(Vector3(current_liquid, current_material, current_catalyst), current_gaunlet_tab)	
	
func _on_tab_container_tab_changed(tab: int) -> void:
	current_gaunlet_tab = tab
	match tab:
		0:
			potion = %Potion0
			gaunlet_left = %GaunletLeft0
			gaunlet_right = %GaunletRight0
		1: 
			potion = %Potion1
			gaunlet_left = %GaunletLeft1
			gaunlet_right = %GaunletRight1
		2:
			potion = %Potion2
			gaunlet_left = %GaunletLeft2
			gaunlet_right = %GaunletRight2
		3:
			potion = %Potion3
			gaunlet_left = %GaunletLeft3
			gaunlet_right = %GaunletRight3
			
	if active_gaunlet_value != tab :
		set_inactive_gaunlet_check()
	else :
		set_active_gaunlet_check()

## GAUNLETS

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
