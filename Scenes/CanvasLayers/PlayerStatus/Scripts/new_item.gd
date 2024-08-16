extends Control

class_name NewItemNotification

const LEAF = preload("res://Scenes/CanvasLayers/AlchemyMenu/Images/leaf.png")
const VINEGAR = preload("res://Scenes/Enemies/Vinegar/vinegar.png")
const STONE_LOOT = preload("res://Scenes/Enemies/Stone/Images/stone_loot.png")
func show_new_message(what : String) -> void:
	%NewItemText.text = "You found some " + what
	match what:
		"leaves":
			%NewItemIcon.texture = LEAF
		"vinegar":
			%NewItemIcon.texture = VINEGAR
		"stones":
			%NewItemIcon.texture = STONE_LOOT
	%NotificationTimer.start()
	%NewItem.show()

func _on_notification_timer_timeout() -> void:
	%NotificationTimer.stop()
	%NewItem.hide()
