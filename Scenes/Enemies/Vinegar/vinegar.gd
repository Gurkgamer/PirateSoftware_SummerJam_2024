extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_pick_up_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" :
		GameManager.enable_ingredient("vinegar")
		queue_free()
		GameManager.show_new_item_notification("vinegar")
