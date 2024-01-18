extends StaticBody2D
@export_file("*.tscn") var next_level

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func interact():
	var next_scene = load(next_level).instantiate()
	get_node("/root/Main").add_child(next_scene)
	get_parent().destroy()
