class_name Checkpoint extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func destroy() -> void:
	get_parent().remove_child(self)
	queue_free()
