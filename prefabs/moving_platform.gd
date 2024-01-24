extends Node

@export var direction: Vector2
@export var speed: float
@export var tilemap: TileMap

@onready var path: Path2D = $Path2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var remote: RemoteTransform2D = $Path2D/PathFollow2D/RemoteTransform2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if direction:
		path.curve.set_point_position(1, direction)
	if speed:
		animation.speed_scale = speed
	if tilemap:
		path.add_child(tilemap.duplicate())
		remote.remote_path = path.get_child(1).get_path()
		tilemap.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
