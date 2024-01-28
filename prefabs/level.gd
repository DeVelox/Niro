extends Node2D
@export var first: TileMap


func _ready() -> void:
# Add a Marker2D called Spawn to change spawn location
	if has_node("Spawn"):
		Data.spawn_point = $Spawn.position
	if not Upgrades.check(Upgrades.Type.VISION):
		get_tree().call_group("hidden", "queue_free")


func destroy(delay: float = 1.0) -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), delay)
	tween.tween_callback(self.queue_free)
