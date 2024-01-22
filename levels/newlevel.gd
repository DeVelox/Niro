extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func destroy(delay = 1.0):
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), delay)
	tween.tween_callback(self.queue_free)
