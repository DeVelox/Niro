extends Node2D

@export_range(0.0, 1.0) var opacity: float = 0.5
var pos: Vector2
var debug_path: Array[Vector2]
@onready var player: Player = $"../Player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_path()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_draw_path()


func _draw() -> void:
	draw_polyline(debug_path, Color.GREEN, 2)


func _init_path() -> void:
	modulate.a = opacity
	debug_path.append(player.global_position)


func _draw_path() -> void:
	pos = player.global_position
	if debug_path.back() != pos:
		debug_path.append(pos)
		queue_redraw()
