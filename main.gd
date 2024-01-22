extends Node
@export_file("*.tscn") var current_scene
@onready var spawn = $Spawn


# Called when the node enters the scene tree for the first time.
func _ready():
	var load_level = load(current_scene).instantiate()
	DataStore.current_level = load_level
	DataStore.current_scene = current_scene
	add_child(load_level)

	var load_player = load("res://player/player.tscn").instantiate()
	if DataStore.spawn_point:
		load_player.position = DataStore.spawn_point
	else:
		load_player.position = spawn.position
	add_child(load_player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
