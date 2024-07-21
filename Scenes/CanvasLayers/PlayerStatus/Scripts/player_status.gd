extends CanvasLayer

func _process(_delta: float) -> void:	
	%SpellProgress0.value = SpellCooldownManager.get_cooldown_remaing_time(%SpellName0.text)
	%SpellProgress1.value = SpellCooldownManager.get_cooldown_remaing_time(%SpellName1.text)
	%SpellProgress2.value = SpellCooldownManager.get_cooldown_remaing_time(%SpellName2.text)
	%SpellProgress3.value = SpellCooldownManager.get_cooldown_remaing_time(%SpellName3.text)
	%SpellProgress0.value = 100 if %SpellProgress0.value == 0 else %SpellProgress0.value
	%SpellProgress1.value = 100 if %SpellProgress1.value == 0 else %SpellProgress1.value
	%SpellProgress2.value = 100 if %SpellProgress2.value == 0 else %SpellProgress2.value
	%SpellProgress3.value = 100 if %SpellProgress3.value == 0 else %SpellProgress3.value

var active_spell_name
var active_spell_icon

func set_active_spell(active_gaunlet_position) -> void:
	var current_font_size
	if active_spell_name : 
		current_font_size = active_spell_name.get("theme_override_font_sizes/font_size")
		active_spell_name.set("theme_override_font_sizes/font_size", current_font_size - 10)
		active_spell_icon.size -= Vector2(20,20)
	
	match active_gaunlet_position:
		0:
			active_spell_name = %SpellName0
			active_spell_icon = %SpellIcon0
		1:
			active_spell_name = %SpellName1
			active_spell_icon = %SpellIcon1
		2:
			active_spell_name = %SpellName2
			active_spell_icon = %SpellIcon2
		3:
			active_spell_name = %SpellName3
			active_spell_icon = %SpellIcon3

	current_font_size = active_spell_name.get("theme_override_font_sizes/font_size")
	active_spell_name.set("theme_override_font_sizes/font_size", current_font_size + 10)
	active_spell_icon.size += Vector2(20,20)
	
var spell_name
var spell_icon
	
func set_gaunlet_data(p_name: String, icon: CompressedTexture2D,  position: int) -> void:
	
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

	spell_name.text = p_name
	spell_icon.texture = icon

func set_player_health(value : int) -> void :
	%HealthBar.value = value
