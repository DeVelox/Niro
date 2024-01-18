extends Node
@export var current_level : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(current_level.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
