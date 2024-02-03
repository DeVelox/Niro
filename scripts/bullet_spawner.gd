extends Node2D

const BULLET = preload("res://prefabs/utility library/bullet.tscn")
const BULLET_SPEED = 500

@export var delay: float = 0.1

var point: Vector2
var i: int = -360
var step: int = 120

@onready var timer: Timer = $Timer
@onready var bullet_spawner: Node2D = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(delay)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	if i < -360:
		step = -step
	if i > 360:
		step = -step
	i += step
	print_debug(i, 0)
	var bullet: Bullet = BULLET.instantiate()
	var direction := Vector2(i, 0)
	bullet.direction = direction
	add_child(bullet)
