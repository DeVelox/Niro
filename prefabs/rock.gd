class_name Rock extends RigidBody2D


func _on_body_entered(body: Node) -> void:
	if body.has_method("try_recall"):
		body.try_recall()
