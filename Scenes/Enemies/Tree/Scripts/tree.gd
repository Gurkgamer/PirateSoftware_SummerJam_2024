extends CharacterBody2D

const LEAFS = preload("res://Scenes/Enemies/Tree/leafs.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Fireball":
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Fireball":
		var loot = LEAFS.instantiate()
		loot.global_position = global_position
		get_tree().root.add_child.call_deferred(loot)
		queue_free()
