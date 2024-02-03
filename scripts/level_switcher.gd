class_name Switcher extends Node2D

@export_file("*.tscn") var next_scene: String
@export var enable_on: TileMap
@export var outro: TileMap
@export var set_player_spawn: bool
@onready var trophy: Area2D = $"."


func _ready() -> void:
	if enable_on:
		Scene.active_tilemap_changed.connect(_on_active_tilemap_change)
		trophy.collision_layer = 0
		trophy.collision_mask = 0


func interact() -> void:
	_play_outro()
	_switch_level()


func _switch_level() -> void:
	trophy.collision_layer = 0
	trophy.collision_mask = 0
	var main := get_node("/root/Main")
	var checkpoint := get_node_or_null("/root/Main/Checkpoint")
	var next_level: Node2D = load(next_scene).instantiate()
	next_level.set_player_spawn = set_player_spawn
	Scene.current_level = next_level
	Scene.current_scene = next_scene
	Scene.active_tilemap.clear()
	main.add_child.call_deferred(next_level)
	if checkpoint:
		checkpoint.destroy()
	get_parent().destroy()


func _play_outro() -> void:
	if outro:
		Scene.fade_out(outro)
		return


func _on_player_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		_play_outro()
		await get_tree().create_timer(1).timeout
		_switch_level()


func _on_active_tilemap_change() -> void:
	if enable_on == Scene.active_tilemap.back():
		trophy.collision_layer = 6
		trophy.collision_mask = 1
