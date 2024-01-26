@tool
extends Node2D

@export_range(0.0, 1.0) var opacity: float = 0.5
var pos : Vector2
@onready var player: Player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = opacity
	DataStore.path.append(player.global_position)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pos = player.global_position
	if DataStore.path.back() != pos:
		DataStore.path.append(pos)
		queue_redraw()
		
func _draw():
	draw_polyline(DataStore.path, Color.GREEN, 2)
