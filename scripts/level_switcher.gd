class_name Switcher extends Node2D

@export_file("*.tscn") var next_scene: String
@export var outro: TileMap
@export var set_player_spawn: bool
@onready var trophy: Area2D = $"."


func interact() -> void:
	await _play_outro()
	_switch_level()


func _switch_level() -> void:
	trophy.collision_layer = 0
	var main := get_node("/root/Main")
	var next_level: Node2D = load(next_scene).instantiate()
	next_level.set_player_spawn = set_player_spawn
	Scene.current_level = next_level
	Scene.current_scene = next_scene
	Scene.active_tilemap.clear()
	main.add_child.call_deferred(next_level)
	get_parent().destroy()


func _play_outro() -> void:
	if outro:
		await Scene.fade_out(outro)
		return


func _on_player_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		await _play_outro()
		_switch_level()
