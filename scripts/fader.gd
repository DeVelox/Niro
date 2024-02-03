class_name Fader extends Area2D

@onready var collision: CollisionShape2D = $CollisionShape2D


func _on_body_entered(body: Node2D) -> void:
	var tilemap: TileMap = get_parent() as TileMap
	if body.is_in_group("players"):
		if tilemap.delay:
			await get_tree().create_timer(tilemap.delay).timeout
		Scene.should_fade.emit(tilemap)
		_disable_collision()


func _disable_collision() -> void:
	collision.set_deferred("disabled", true)
