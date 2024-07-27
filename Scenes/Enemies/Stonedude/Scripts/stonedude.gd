extends CharacterBody2D

const SPEED = 300.0
var shield_health = 8
var health = 1

const STONEPICKUP = preload("res://Scenes/Enemies/Stone/stonepickup.tscn")
const STONEBULLET = preload("res://Scenes/Enemies/Stonedude/stonebullet.tscn")
@onready var shadowstone: Sprite2D = %Shadowstone

@onready var shield_sprite: Sprite2D = %ShieldSprite
var player
@onready var stone_body_sprite: Sprite2D = %StoneBodySprite

var float_tween
var shadow_tween

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	float_tween = create_tween()
	shadow_tween = create_tween()
	float_tween.set_loops()
	shadow_tween.set_loops()
	play_floating_animation()
	%ShootTimer.start()

func _physics_process(delta: float) -> void:
	if is_instance_valid(shield_sprite) :
		shield_sprite.look_at(player.global_position)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.name == "Fireball" or area.name == "Hardball") and is_instance_valid(shield_sprite):
		area.get_parent().queue_free()
		shield_health -= 1
		var tween = create_tween()
		var original_modulate = modulate
		tween.tween_property(shield_sprite, "modulate:v", 15, 0.01)
		tween.tween_property(shield_sprite, "modulate", original_modulate, 0.01)
		
	if shield_health <= 0:
		%ShieldSprite.queue_free()
		
func _on_stone_area_area_entered(area: Area2D) -> void:
	if (area.name == "Fireball" or area.name == "Hardball") :
		area.get_parent().queue_free()
		health -= 1
		var original_modulate = modulate
		var tween2 = create_tween()
		tween2.tween_property(self, "modulate:v", 15, 0.01)
		tween2.tween_property(self, "modulate", original_modulate, 0.01)
	if health <= 0:
		var stone_loot = STONEPICKUP.instantiate()
		stone_loot.global_position = global_position
		get_tree().root.add_child.call_deferred(stone_loot)
		queue_free()

func play_floating_animation() -> void:
	var position_offset := Vector2(0.0, 4.0)
	var original_scale_x = scale.x
	var size_x_change := 0.7
	var duration := 1.0
	float_tween.tween_property(stone_body_sprite, "position", position_offset, duration)
	shadow_tween.tween_property(shadowstone, "scale:x", size_x_change, duration)
	float_tween.tween_property(stone_body_sprite, "position",  -1.0 * position_offset, duration)
	shadow_tween.tween_property(shadowstone, "scale:x", original_scale_x, duration)

var bullet_counter : int = 0
const MAX_BULLETS : int = 5

func _on_shoot_timer_timeout() -> void:
	var new_bullet = STONEBULLET.instantiate()
	var direction_vector = (player.global_position - global_position).normalized()
	new_bullet.global_position = global_position + 5 * direction_vector
	get_tree().root.add_child(new_bullet)
	bullet_counter += 1
	if bullet_counter >= MAX_BULLETS:
		%ShootTimer.stop()
		get_tree().create_timer(3).timeout.connect(func()->void: 
			bullet_counter = 0
			if !outside_vision :
				%ShootTimer.start()
			)

func _on_vision_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		outside_vision = false
		%ShootTimer.start()

var outside_vision : bool = true

func _on_vision_area_body_exited(body: Node2D) -> void:
	if body.name == "Player" and !is_queued_for_deletion():
		outside_vision = true
		%ShootTimer.stop()
