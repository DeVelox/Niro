extends Area2D
signal spawn


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("players"):
		emit_signal("spawn", position)
		print(position)
		#for level_1_set_1 in get_tree().get_nodes_in_group("level_1_set_1"):
			#level_1_set_1.queue_free()
			#for level_1_set_2 in get_tree().get_nodes_in_group("level_1_set_2"):
				#level_1_set_2.show()
				
