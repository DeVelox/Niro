class_name Fader extends Area2D

@onready var collision: CollisionShape2D = $CollisionShape2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		if Scene.can_fade:
			Scene.is_fading = true
		get_tree().call_group("fader", "disable_collision")


func disable_collision():
	collision.set_deferred("disabled", true)
