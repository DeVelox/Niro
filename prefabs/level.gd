extends Node2D


func _ready() -> void:
# Add a Marker2D called Spawn to change spawn location
	if has_node("Spawn"):
		DataStore.spawn_point = $Spawn.position


func destroy(delay: float = 1.0) -> void:
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), delay)
	tween.tween_callback(self.queue_free)
