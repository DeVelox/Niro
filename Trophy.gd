extends StaticBody2D
@export_file("*.tscn") var next_level
	
func interact():
	var next_scene = load(next_level).instantiate()
	get_node("/root/Main").add_child(next_scene)
	get_parent().destroy()
