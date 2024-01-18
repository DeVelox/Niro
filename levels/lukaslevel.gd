extends Node2D

var level = 1
var sets = 1
@onready var spawn := Vector2(60,20)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#pass
	print(spawn[0])
	print(spawn[1])


func _on_checkpoint_spawn():
	pass # Replace with function body.
