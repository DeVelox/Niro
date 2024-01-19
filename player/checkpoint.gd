extends Node2D
var checkpoint_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	checkpoint_scene = get_node("/root/Main").current_scene
	position = get_node("/root/Main/Player").global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func destroy():
	get_node("/root/Main/Player").has_checkpoint = false
	queue_free()
