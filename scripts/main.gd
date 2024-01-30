extends Node
@export_file("*.tscn") var current_scene: String
@onready var spawn: Marker2D = $Spawn


# Called when the node enters the scene tree for the first time.
func _ready():
	var load_level: Node2D = load(current_scene).instantiate()
	Scene.current_level = load_level
	Scene.current_scene = current_scene
	add_child(load_level)

	var load_player: Player = load("res://player/player.tscn").instantiate()
	if Data.spawn_point:
		load_player.position = Data.spawn_point
	else:
		load_player.position = spawn.position
	add_child(load_player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
