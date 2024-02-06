class_name Switcher extends Node2D

@export_file("*.tscn") var next_scene: String
@export_enum(
	"TRACK1",
	"TRACK2",
	"TRACK3",
	"TRACK4",
	"TRACK5",
	"TRACK6",
	"TRACK7",
	"TRACK8",
	"TRACK9",
	"TRACK10",
	"TRACK11",
	"TRACK12"
)
var music: String
@export var enable_on: TileMap
@export var outro: TileMap
@export var keep_player_position: bool
@export var going_to_cave: bool

@onready var trophy: Area2D = $"."


func _ready() -> void:
	if enable_on:
		Scene.active_tilemap_changed.connect(_on_active_tilemap_change)
		trophy.collision_layer = 0
		trophy.collision_mask = 0
		trophy.hide()


func interact() -> void:
	_play_outro()
	_switch_level()


func _switch_level() -> void:
	get_tree().call_group("textbox", "queue_free")
	trophy.collision_layer = 0
	trophy.collision_mask = 0
	var main := get_node_or_null("/root/Main")
	var next_level: Node2D = load(next_scene).instantiate()
	Data.set_player_spawn = keep_player_position
	Data.set_current_track = music
	Scene.current_level = next_level
	Scene.current_scene = next_scene
	Scene.active_tilemap.clear()

	if going_to_cave:
		main.current_scene = next_scene

	if is_instance_valid(main):
		next_level.request_ready()
		main.add_child.call_deferred(next_level)
	else:
		return

	get_parent().destroy()


func _play_outro() -> void:
	if outro:
		Scene.fade_out(outro)
		return


func _on_player_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		Data.set_player_position = body.position
		_play_outro()
		_switch_level()


func _on_active_tilemap_change() -> void:
	if enable_on == Scene.active_tilemap.back():
		trophy.collision_layer = 6
		trophy.collision_mask = 1
		trophy.show()
