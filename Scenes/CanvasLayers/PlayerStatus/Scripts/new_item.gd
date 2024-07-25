extends Control

class_name NewItemNotification

const LEAF = preload("res://Scenes/CanvasLayers/AlchemyMenu/Images/leaf.png")

func show_new_message(what : String) -> void:
	%NewItemText.text = "You found some " + what + "s"
	match what:
		"leaf":
			%NewItemIcon.texture = LEAF
	%NotificationTimer.start()
	%NewItem.show()

func _on_notification_timer_timeout() -> void:
	%NotificationTimer.stop()
	%NewItem.hide()
