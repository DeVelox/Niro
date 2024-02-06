extends Node2D

var timer: float = 0

@onready var point_light_2d: PointLight2D = $PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Sound.crossfade(Sound.TRACK_8)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	if timer > 4 * delta:
		point_light_2d.energy = clamp(randfn(0.8, 0.1), 0.0, 1.0)
		timer = 0

	if Input.is_action_just_pressed("jump"):
		get_tree().change_scene_to_file("res://main.tscn")
