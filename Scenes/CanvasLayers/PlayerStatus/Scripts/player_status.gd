extends CanvasLayer

@onready var health: Label = %Health

func set_player_hearlth(value : int) -> void:
	%Health.text = str(value)
	

var active_spell_name
var active_spell_icon

func set_active_spell(active_gaunlet_position) -> void:
	print("poniendo activo")
	var current_font_size
	if active_spell_name : 
		print("A")
		current_font_size = active_spell_name.get("theme_override_font_sizes/font_size")
		active_spell_name.set("theme_override_font_sizes/font_size", current_font_size - 10)
		active_spell_icon.size -= Vector2(20,20)
	
	match active_gaunlet_position:
		0:
			print("B")
			active_spell_name = %SpellName0
			active_spell_icon = %SpellIcon0
		1:
			print("C")
			active_spell_name = %SpellName1
			active_spell_icon = %SpellIcon1
		2:
			print("D")
			active_spell_name = %SpellName2
			active_spell_icon = %SpellIcon2
		3:
			print("A")
			active_spell_name = %SpellName3
			active_spell_icon = %SpellIcon3

	print("E")
	current_font_size = active_spell_name.get("theme_override_font_sizes/font_size")
	active_spell_name.set("theme_override_font_sizes/font_size", current_font_size + 10)
	print(active_spell_icon.name)
	print(active_spell_icon.size)
	active_spell_icon.size += Vector2(20,20)
	print(active_spell_icon.size)
	
var spell_name
var spell_icon
	
func set_gaunlet_data(name: String, icon: CompressedTexture2D,  position: int) -> void:
	
	match position:
		0:
			spell_name = %SpellName0
			spell_icon = %SpellIcon0
		1:
			spell_name = %SpellName1
			spell_icon = %SpellIcon1
		2:
			spell_name = %SpellName2
			spell_icon = %SpellIcon2
		3:
			spell_name = %SpellName3
			spell_icon = %SpellIcon3

	spell_name.text = name
	spell_icon.texture = icon
