extends CharacterBody2D

var cooldown = 1.5
var spell_direction : Vector2
var ball_speed : float = 500.0
const HARDBALL = preload("res://Scenes/AlchemySpells/Hardball/hardball.tscn")
var family_tree := 0
var player
var damage = 4

func initialize(p_player : CharacterBody2D, mouse_direction : Vector2) -> void:
	spell_direction = mouse_direction
	player = p_player
	global_position = player.global_position + mouse_direction * 20
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage = damage / (family_tree + 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = ball_speed * spell_direction
	move_and_slide()
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name== "Player": return
	
	if body.is_in_group("Enemy"):
		body.take_damage(damage)
		queue_free()
	
	if family_tree < 2 :
		family_tree+=1
		spell_direction = spell_direction.bounce(spell_direction.normalized())
		var new_ball_1 : CharacterBody2D = HARDBALL.instantiate()
		var new_ball_2 : CharacterBody2D = HARDBALL.instantiate()
		#TODO -> Esto no vota 100% bien si la velocidad no es alta, mirar a ver si en el inicialize se puede hacer algo
		var new_direction_positive = spell_direction.rotated(deg_to_rad(45)) 
		var new_direction_negative = spell_direction.rotated(deg_to_rad(-45))
		new_ball_1.initialize(self, new_direction_positive)
		new_ball_2.initialize(self, new_direction_negative)
		new_ball_1.set_family_value(family_tree)
		new_ball_2.set_family_value(family_tree)
		new_ball_1.scale = self.scale / 1.5
		new_ball_2.scale = self.scale / 1.5
		get_tree().root.add_child.call_deferred(new_ball_1)
		get_tree().root.add_child.call_deferred(new_ball_2)
	queue_free()
	
func set_family_value(value : int) -> void:
	family_tree = value
