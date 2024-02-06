extends Node

var debug_bools: Array[String]
var debug_values: Array[String]

var has_checkpoint: bool
var set_player_spawn: bool
var set_current_track: String
var set_player_position: Vector2


func _ready() -> void:
	pass
	#var window := get_window().size
	#var display := DisplayServer.screen_get_size(DisplayServer.SCREEN_WITH_MOUSE_FOCUS)
	#get_window().set_deferred("size", 2 * window)
	#get_window().set_deferred("position", (display / 2) - window)
