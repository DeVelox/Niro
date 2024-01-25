class_name Rock extends RigidBody2D


func _on_body_entered(body: Node) -> void:
	if body.has_method("damage"):
		body.damage()
