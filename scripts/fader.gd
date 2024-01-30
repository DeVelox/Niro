class_name Fader extends Area2D

@onready var collision: CollisionShape2D = $CollisionShape2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		Scene.should_fade.emit(get_parent())
		_disable_collision()


func _disable_collision():
	collision.set_deferred("disabled", true)
