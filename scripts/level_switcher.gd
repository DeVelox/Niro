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
@export var set_player_spawn: bool

@onready var trophy: Area2D = $"."


func _ready() -> void:
	if enable_on:
		Scene.active_tilemap_changed.connect(_on_active_tilemap_change)
		trophy.collision_layer = 0
		trophy.collision_mask = 0


func interact() -> void:
	_play_outro()
	_switch_level()


func _switch_level() -> void:
	_music()
	trophy.collision_layer = 0
	trophy.collision_mask = 0
	var main := get_node("/root/Main")
	var checkpoint := get_node_or_null("/root/Main/Checkpoint")
	var next_level: Node2D = load(next_scene).instantiate()
	next_level.set_player_spawn = set_player_spawn
	Scene.current_level = next_level
	Scene.current_scene = next_scene
	Scene.active_tilemap.clear()
	main.add_child.call_deferred(next_level)
	if checkpoint:
		checkpoint.destroy()
	get_parent().destroy()


func _play_outro() -> void:
	if outro:
		Scene.fade_out(outro)
		return


func _on_player_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		_play_outro()
		await get_tree().create_timer(1).timeout
		_switch_level()


func _on_active_tilemap_change() -> void:
	if enable_on == Scene.active_tilemap.back():
		trophy.collision_layer = 6
		trophy.collision_mask = 1


func _music() -> void:
	match music:
		"TRACK1":
			Sound.crossfade(Sound.TRACK_1)
		"TRACK2":
			Sound.crossfade(Sound.TRACK_2)
		"TRACK3":
			Sound.crossfade(Sound.TRACK_3)
		"TRACK4":
			Sound.crossfade(Sound.TRACK_4)
		"TRACK5":
			Sound.crossfade(Sound.TRACK_5)
		"TRACK6":
			Sound.crossfade(Sound.TRACK_6)
		"TRACK7":
			Sound.crossfade(Sound.TRACK_7)
		"TRACK8":
			Sound.crossfade(Sound.TRACK_8)
		"TRACK9":
			Sound.crossfade(Sound.TRACK_9)
		"TRACK10":
			Sound.crossfade(Sound.TRACK_10)
		"TRACK11":
			Sound.crossfade(Sound.TRACK_11)
		"TRACK12":
			Sound.crossfade(Sound.TRACK_12)
