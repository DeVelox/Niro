extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	position = get_node("/root/Main/Player").global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func destroy():
	get_parent().remove_child(self)
	queue_free()
