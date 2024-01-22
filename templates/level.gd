extends Node2D
@onready var spawn = $Spawn


func _ready():
# Add a Marker2D called Spawn to change spawn location
	if spawn:
		DataStore.spawn_point = spawn.position


func destroy(delay = 1.0):
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), delay)
	tween.tween_callback(self.queue_free)
