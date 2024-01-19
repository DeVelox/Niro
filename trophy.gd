extends StaticBody2D
@export_file("*.tscn") var next_scene
	
func interact():
	var next_level = load(next_scene).instantiate()
	get_node("/root/Main").add_child(next_level)
	get_parent().destroy()
