extends Node

var debug_bools: Array[String]
var debug_values: Array[String]


func _ready():
	var window := get_window().size
	#var display := DisplayServer.screen_get_size()
	get_window().set_deferred("size", 2 * window)
	#get_window().set_deferred("position", (display / 2) - window)
