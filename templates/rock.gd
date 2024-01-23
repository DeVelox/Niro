extends RigidBody2D


func _on_area_2d_body_entered(body):
	if body.has_method("try_recall"):
		body.try_recall()
