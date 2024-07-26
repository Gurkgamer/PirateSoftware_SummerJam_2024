extends CharacterBody2D

signal gaunlet_changed(direction : bool)
signal health_change(new_health : int)
@onready var body_sprite: AnimatedSprite2D = %BodySprite
@onready var hand_sprite: AnimatedSprite2D = $HandSprite
var health : int = 100 :
	get:
		return health
	set (value):
		health = clamp(value, 0, 100)
		health_change.emit(health)
var speed = 300.0
var dash_speed = 500.0
const PLAYER_DASH_TRAIL = preload("res://Scenes/Player/player_dash_trail.tscn")
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
		velocity = knockback_normalized_direction * speed * knockback_strength
	elif direction and !knockback_normalized_direction:
		velocity = direction * speed
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
	
	if dashing :
		var dash_trail_instance = PLAYER_DASH_TRAIL.instantiate()
		dash_trail_instance.flip_h = body_sprite.flip_h
		dash_trail_instance.global_position = global_position
		get_parent().add_child(dash_trail_instance)
	
	%DashCooldown.value = (%DashCooldownTimer.time_left * 100) / %DashCooldownTimer.wait_time
	print(%DashCooldown.value)
	%DashCooldown.visible = false if %DashCooldown.value == 0 else true
	
	move_and_slide()

var dashing : bool = false
var dashing_cooldown : bool = false

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
	
	if event.is_action_pressed("Dash") and !dashing and !dashing_cooldown:
		speed = speed + dash_speed
		dashing = true
		dashing_cooldown = true
		%DashCooldownTimer.start()
		get_tree().create_timer(0.2).timeout.connect(func()->void :
			speed = speed - dash_speed
			dashing = false
			)
			
func _on_dash_cooldown_timer_timeout() -> void:
	dashing_cooldown = false


func set_spell(spell : PackedScene) -> void:
	spell_scene = spell
	
func take_health(quantity : int) -> void:
	print("Healing")
	health += quantity

func take_damage(quantity : int, reason) -> void:
	if !shield_up :
		health -= quantity
	knockback(reason)
	
func knockback(body_hit) -> void:
	knockback_normalized_direction = body_hit.global_position.direction_to(global_position) # Direccion hacia el jugador, normalizado

func set_shield(state : bool)-> void:
	shield_up = state
