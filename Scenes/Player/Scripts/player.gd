extends CharacterBody2D

signal gaunlet_changed(direction : bool)
signal health_change(new_health : int)
@onready var body_sprite: AnimatedSprite2D = %BodySprite
@onready var hand_sprite: AnimatedSprite2D = $HandSprite

var health : int = 100
const SPEED = 300.0
var spell_scene : PackedScene
var knockback_strength : float = 10
var knockback_normalized_direction = Vector2(0,0)
var shield_up : bool = false

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("Left","Right","Up","Down")
	
	#Evitar que le jugador se mueva mientras es golpeado
	if knockback_normalized_direction :
		direction = Vector2.ZERO
	
	if knockback_normalized_direction and !direction:
		velocity = knockback_normalized_direction * SPEED * knockback_strength
	elif direction and !knockback_normalized_direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
		
	knockback_normalized_direction = Vector2(move_toward(knockback_normalized_direction.x, 0, 0.1),move_toward(knockback_normalized_direction.y, 0, 0.1))
	
	if velocity:
		body_sprite.play("walk")
	else:
		body_sprite.stop()
		
	if get_local_mouse_position().x > 0:
		body_sprite.flip_h = true
		hand_sprite.flip_h = true
	else:
		body_sprite.flip_h = false
		hand_sprite.flip_h = false
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Cast") and spell_scene:
		var casted_spell = spell_scene.instantiate()
		if SpellCooldownManager.can_be_cast(casted_spell) :
			if casted_spell.name == "Nothing":
				hand_sprite.speed_scale = 3
			else : 
				hand_sprite.speed_scale = 1
			%ClapSFX.play()
			hand_sprite.play("clap")
			var mouse_direction = (get_global_mouse_position() - global_position).normalized()
			casted_spell.initialize(self, mouse_direction)
			get_tree().root.add_child(casted_spell)
	
	if event.is_action_pressed("SwapLeft") && !event.is_action_pressed("SwapRight"):
		gaunlet_changed.emit(false)
	elif event.is_action_pressed("SwapRight") && !event.is_action_pressed("SwapLeft"):
		gaunlet_changed.emit(true)

func set_spell(spell : PackedScene) -> void:
	spell_scene = spell

func take_damage(quantity : int, reason) -> void:
	if !shield_up :
		health -= quantity
		health_change.emit(health)
	knockback(reason)
	
func knockback(body_hit) -> void:
	knockback_normalized_direction = body_hit.global_position.direction_to(global_position) # Direccion hacia el jugador, normalizado

func set_shield(state : bool)-> void:
	shield_up = state
