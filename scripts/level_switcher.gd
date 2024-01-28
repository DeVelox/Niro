extends Node2D
@export_file("*.tscn") var next_scene: String
@onready var trophy: Area2D = $"."


func interact() -> void:
	_switch_level()


func _switch_level() -> void:
	trophy.collision_layer = 0
	var main := get_node("/root/Main")
	var next_level: Node2D = load(next_scene).instantiate()
	Data.current_level = next_level
	Data.current_scene = next_scene
	Data.scene_history.append(next_scene)
	main.call_deferred("add_child", next_level)
	get_parent().destroy()


func _on_player_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		_switch_level()
