extends HBoxContainer

## SPELLBOOK ENTRY

signal assign_notebook_formula(formula_vector3 : Vector3)

var formula_name: String
var formula_combination : Vector3

func _on_assign_button_pressed() -> void:
	assign_notebook_formula.emit(formula_combination)

func set_formula_entry(formula_vector : Vector3, spell_entry) -> void:
	formula_combination = formula_vector
	%SpellIcon.texture = spell_entry["icon"]
	%FormulaName.text = spell_entry["name"]
	formula_name = spell_entry["name"]
		
