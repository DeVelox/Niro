extends Node
@export_file("*.tscn") var current_scene: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var load_level: Node2D = load(current_scene).instantiate()
	Scene.current_level = load_level
	Scene.current_scene = current_scene
	add_child(load_level)

	Sound.music(Sound.TRACK_10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass
