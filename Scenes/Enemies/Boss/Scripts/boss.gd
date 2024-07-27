extends Node2D

const STONEDUDE = preload("res://Scenes/Enemies/Stonedude/stonedude.tscn")
const SHADOW_CREATURE = preload("res://Scenes/Enemies/ShadowCreature/shadow_creature.tscn")

@onready var spawn_timer: Timer = %SpawnTimer
@onready var health_bar: ProgressBar = %HealthBar
@onready var shadow_spawn_1: Marker2D = %ShadowSpawn1
@onready var shadow_spawn_2: Marker2D = %ShadowSpawn2
@onready var shadow_spawn_3: Marker2D = %ShadowSpawn3
@onready var shadow_spawn_4: Marker2D = %ShadowSpawn4
@onready var stone_spawn_1: Marker2D = %StoneSpawn1
@onready var stone_spawn_2: Marker2D = %StoneSpawn2

var max_health = 200
var health = 200

var spawned_enemies = {
	"shadow1": null,
	"shadow2": null,
	"shadow3": null,
	"shadow4": null,
	"stone1": null,
	"stone2": null,
}
func _ready() -> void:
	%CanvasLayer.visible = false

func _process(delta: float) -> void:
	health_bar.value = (health * 100) / max_health

func check_spawns() -> void:
	for next_spawn_key in spawned_enemies.keys():
		var new_enemy_instance
		if !is_instance_valid(spawned_enemies[next_spawn_key]) :
			match next_spawn_key:
				"shadow1":
					new_enemy_instance = spawm_shadow(shadow_spawn_1)
				"shadow2":
					new_enemy_instance = spawm_shadow(shadow_spawn_2)
				"shadow3":
					new_enemy_instance = spawm_shadow(shadow_spawn_3)
				"shadow4":
					new_enemy_instance = spawm_shadow(shadow_spawn_4)
				"stone1":
					new_enemy_instance = spawn_stone(stone_spawn_1)
				"stone2":
					new_enemy_instance = spawn_stone(stone_spawn_2)
		
		if new_enemy_instance:
			spawned_enemies[next_spawn_key] = new_enemy_instance
	
func spawm_shadow(marker_position : Marker2D) -> Node2D:
	var new_shadow_enemy = SHADOW_CREATURE.instantiate()
	new_shadow_enemy.global_position = marker_position.to_global(marker_position.position)
	get_tree().root.add_child.call_deferred(new_shadow_enemy)
	return new_shadow_enemy
	
func spawn_stone(marker_position : Marker2D) -> Node2D:
	var new_stone_enemy = STONEDUDE.instantiate()
	new_stone_enemy.global_position = marker_position.to_global(marker_position.position)
	get_tree().root.add_child.call_deferred(new_stone_enemy)
	return new_stone_enemy

func _on_spawn_timer_timeout() -> void:
	check_spawns()

func take_damage(hit_points: int)->void:
	health -= hit_points
	if health <= 0:
		get_tree().root.add_child(CREDITS.instantiate())
		
const CREDITS = preload("res://Scenes/Credits/credits.tscn")
var once : bool = false
var boss_on_screen : bool = false

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if !once:
		boss_on_screen = true
		spawn_timer.start()
		once = true
		check_spawns()
		%CanvasLayer.visible = true
