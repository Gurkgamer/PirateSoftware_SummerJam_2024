extends CharacterBody2D

signal gaunlet_changed(direction : bool)
signal health_change(new_health : bool)

var health : int = 100
const SPEED = 300.0
const PROYECTIL = preload("res://Scenes/AlchemySpells/Test/proyectil.tscn")
var spell_scene : PackedScene
@onready var cooldown_timer: Timer = %CoolDownTimer
var on_cooldown : bool = false

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("Left","Right","Up","Down")
	
	global_position += direction * delta * SPEED

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

func _on_cool_down_timer_timeout() -> void:
	on_cooldown = false
