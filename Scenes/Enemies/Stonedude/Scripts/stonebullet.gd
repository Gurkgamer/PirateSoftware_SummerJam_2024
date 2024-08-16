extends CharacterBody2D

const SPEED = 8.0
var direction_vector : Vector2
var player : CharacterBody2D
var damage = 2

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	direction_vector = (player.global_position - global_position).normalized()

func _physics_process(delta: float) -> void:
	
	velocity = direction_vector * SPEED

	var collision = move_and_collide(velocity)
	if collision :
		var something = collision.get_collider()
		if something is CharacterBody2D and something.is_in_group("Enemy"):
			queue_free()
			return
		var what = collision.get_collider().name
		if what == "TileMapLayer" :
			queue_free()
		elif what == "Player" :
			player.take_damage(damage, self)
			queue_free()
		elif what == "Ivy" or what == "ShadowCreature" or what =="Boss":
			queue_free()
		elif what == "Stonedude":
			pass
