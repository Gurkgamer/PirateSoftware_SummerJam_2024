extends Node2D

func _on_pick_up_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" :
		GameManager.enable_ingredient("vinegar")
		queue_free()
		GameManager.show_new_item_notification("vinegar")
