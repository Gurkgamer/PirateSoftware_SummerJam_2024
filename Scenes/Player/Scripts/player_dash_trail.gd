extends Sprite2D

func _process(delta: float) -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a",0,0.1).finished.connect(func() -> void: queue_free())
