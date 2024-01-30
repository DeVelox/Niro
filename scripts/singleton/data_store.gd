extends Node

var current_scene: String
var current_level: Node2D
var scene_history: Array[String]

var spawn_point: Vector2

var debug_bools: Array[String]
var debug_values: Array[String]

var iveseenthisfuckerbefore: bool
var hehasntboughtshit: bool


func _ready():
	var window := get_window().size
	var display := DisplayServer.screen_get_size()
	get_window().set_deferred("size", 2 * window)
	get_window().set_deferred("position", (display / 2) - window)
