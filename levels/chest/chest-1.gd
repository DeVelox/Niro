extends Node2D


func _ready():
	pass


func destroy(delay = 1):
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), delay)
	tween.tween_callback(self.queue_free)
