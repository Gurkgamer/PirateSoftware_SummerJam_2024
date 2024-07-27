extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" :
		GameManager.enable_ingredient("leather")
		queue_free()
		GameManager.show_new_item_notification("stones")
