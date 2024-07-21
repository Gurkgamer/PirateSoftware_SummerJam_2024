extends CharacterBody2D

@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var idle_timer: Timer = %IdleTimer
const ENEMY_ATTACK = preload("res://Scenes/EnemyAttacks/enemy_attack.tscn")
@onready var attack_timer: Timer = %AttackTimer
var attack_cooldown : float = 2.0
var attack_strengh : int = 4

var is_inside_screen : bool = false
var following_objective : CharacterBody2D
var default_speed : float = 70.0
var speed_brightness_boost : float = 20.0
var speed : float

enum states{
	IDLE,
	FOLLOW,
	ATTACK
}

@onready var brightness_level_label: Label = %BrightnessLevelLabel #DEBUG
@onready var speed_level_label: Label = %SpeedLevelLabel #DEBUG
@onready var state_label: Label = $Control/HBoxContainer3/StateLabel #DEBUG

var current_state : states

func _ready() -> void:
	current_state = states.IDLE
	idle_timer.start()
	if !following_objective:
		following_objective = get_tree().get_first_node_in_group("Player")
	attack_timer.wait_time = attack_cooldown
	
func _process(delta: float) -> void:
	set_speed()
	
	match current_state:
		states.IDLE:
			play_idle(delta)
		states.FOLLOW:
			play_follow(delta)
			animated_sprite_2d.play("walk")
		states.ATTACK:
			play_attack(delta)
	state_label.text = str(states.keys()[current_state])
	move_and_slide()

func set_speed() -> void:
	var brigthness_level = BrightnessManager.get_brigthness() # entre 0 y 1
	brightness_level_label.text = str(brigthness_level)
	speed = default_speed + (speed_brightness_boost * brigthness_level)
	speed_level_label.text = str(speed)

var rng = RandomNumberGenerator.new()

func play_idle(delta : float) -> void:
	velocity = Vector2.ZERO
	if idle_timer.is_stopped() :
		idle_timer.start()

func _on_idle_timer_timeout() -> void:
	var new_position_x = rng.randf_range(global_position.x - 100, global_position.x + 100)
	var new_position_y = rng.randf_range(global_position.y + 200, global_position.y - 100)
	animated_sprite_2d.play("walk")
	var tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(new_position_x,new_position_y), 2).finished.connect(func() -> void : animated_sprite_2d.stop())
	
func play_follow(delta : float) -> void:
	idle_timer.stop()
	var direction = (following_objective.global_position - global_position).normalized()
	velocity = direction * speed 
	
func play_attack(delta : float) -> void:
	idle_timer.stop()
	if attack_timer.is_stopped():
		attack_timer.start()
	velocity = Vector2.ZERO
	
func _on_attack_timer_timeout() -> void:
	var current_brightnees = int(BrightnessManager.get_brigthness() * 10)
	var total_strenght = attack_strengh + current_brightnees
	var new_attack = ENEMY_ATTACK.instantiate()
	new_attack.set_values(total_strenght, following_objective)
	add_child(new_attack)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_inside_screen = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	is_inside_screen = false

func _on_vision_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		current_state = states.FOLLOW

func _on_vision_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		current_state = states.IDLE
		animated_sprite_2d.stop()

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		current_state = states.ATTACK

func _on_damage_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		current_state = states.FOLLOW
		attack_timer.stop()
