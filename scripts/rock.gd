class_name Rock extends RigidBody2D


func _on_body_entered(body: Node) -> void:
	if body.has_method("damage"):
		body.damage()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("is_safe"):
		body.is_safe()
