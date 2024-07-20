extends ColorRect

## FORMULA NOTEBOOK

signal return_from_notebook_entries()

@onready var entry_container: VBoxContainer = %EntryContainer
const NOTEBOOK_ENTRY_CONTAINER = preload("res://Scenes/CanvasLayers/FormulaNotebook/NotebookEntry/notebook_entry_container.tscn")

#CHORE -> POnerle el tipo de retorno o no me molesto?
func add_notebook_entry(formula_vector : Vector3): # Para saber si es una entrada
	print("Recibo vector magia		: " + str(formula_vector))
	var spell_entry = GameManager.spell_library[formula_vector]
	if spell_entry is String : #TODO -> Que hacer ocn el nothing
		return null
	
	for next_entry in entry_container.get_children():
		if spell_entry["name"] == next_entry.formula_name:
			return null
			
	var notebook_entry_instance = NOTEBOOK_ENTRY_CONTAINER.instantiate()
	notebook_entry_instance.set_formula_entry(formula_vector, spell_entry)
	entry_container.add_child(notebook_entry_instance)
	return notebook_entry_instance

# SUGGESTION -> CUando entre una entrada nueva, reordenar los nodos alfabeticamente o mantener en orden de entrada (otro tipos de orden)

#TODO -> Poner bonito
func _on_button_1_pressed() -> void:
	return_from_notebook_entries.emit()
