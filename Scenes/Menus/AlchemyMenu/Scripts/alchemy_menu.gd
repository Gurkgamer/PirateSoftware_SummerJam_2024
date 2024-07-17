extends Control

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
var current_liquid : liquids:
	get:
		return current_liquid
	set (value):
		print("Chosen liquid: " + str(liquids.keys()[value]))
		current_liquid = value
var current_material : materials
var current_catalyst : catalysts

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_tab_container_tab_changed(tab: int) -> void:
	#TODO Si cambia la pestaña -> cargar la configuracion de alquimia a las variables
	pass # Replace with function body.

func _on_water_texture_toggled(toggled_on: bool) -> void:	
	if toggled_on:
		current_liquid = liquids.WATER

func _on_vinegar_texture_toggled(toggled_on: bool) -> void:
	if toggled_on:
		current_liquid = liquids.VINEGAR

func _on_oil_texture_toggled(toggled_on: bool) -> void:
	if toggled_on:
		current_liquid = liquids.OIL

func _on_alcohol_texture_toggled(toggled_on: bool) -> void:
	if toggled_on:
		current_liquid = liquids.ALCOHOL
