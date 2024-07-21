extends CharacterBody2D

signal gaunlet_changed(direction : bool)
signal health_change(new_health : int)

var health : int = 100
const SPEED = 300.0
var spell_scene : PackedScene
var knockback_strength : float = 4.0

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("Left","Right","Up","Down")
	
	velocity = direction * SPEED
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Cast") and spell_scene:
		var casted_spell = spell_scene.instantiate()
		if SpellCooldownManager.can_be_cast(casted_spell) :
			%ClapSFX.play()
			var mouse_direction = (get_global_mouse_position() - position).normalized()
			casted_spell.initialize(self, mouse_direction)
			get_tree().root.add_child(casted_spell)
	
	if event.is_action_pressed("SwapLeft") && !event.is_action_pressed("SwapRight"):
		gaunlet_changed.emit(false)
	elif event.is_action_pressed("SwapRight") && !event.is_action_pressed("SwapLeft"):
		gaunlet_changed.emit(true)

func set_spell(spell : PackedScene) -> void:
	spell_scene = spell

func take_damage(quantity : int, reason) -> void:
	health -= quantity
	health_change.emit(health)
	knockback(reason)
	
func knockback(body_hit) -> void:
	var direction = global_position.direction_to(body_hit.global_position)
	var explosion_force = direction * knockback_strength
	velocity += - explosion_force
	print("pip")
	
