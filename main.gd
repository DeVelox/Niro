extends Node
@export_file("*.tscn") var current_level

# Called when the node enters the scene tree for the first time.
func _ready():
	var load_level = load(current_level).instantiate()
	add_child(load_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
