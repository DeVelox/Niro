extends Node2D
@export_file("*.tscn") var next_scene
	
func interact():
	var main = get_node("/root/Main")
	var next_level = load(next_scene).instantiate()
	main.current_level = next_level
	main.current_scene = next_scene
	main.add_child(next_level)
	get_parent().destroy()
