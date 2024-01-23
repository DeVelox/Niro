extends Node2D
@export_file("*.tscn") var next_scene
@onready var trophy: Area2D = $"."


func interact():
	trophy.collision_layer = 0
	var main = get_node("/root/Main")
	var next_level = load(next_scene).instantiate()
	DataStore.current_level = next_level
	DataStore.current_scene = next_scene
	DataStore.scene_history.append(next_scene)
	main.add_child(next_level)
	get_parent().destroy()
