extends Node2D

const BULLET = preload("res://prefabs/utility library/bullet.tscn")
const BULLET_SPEED = 500

@export var delay: float = 0.1

var point: Vector2
var i: int = -320
var x: int = 0
var y: int = 0
var step: int = 1

@onready var timer: Timer = $Timer
@onready var bullet_spawner: Node2D = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(delay)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	if i > 320:
		step = -1
	if i < -320:
		step = 1
	i += step
	x += 1
	y += 1
	var bullet: Bullet = BULLET.instantiate()
	var direction := Vector2((x % 360) - 180, (y % 360) - 180)
	bullet.direction = direction.normalized() * BULLET_SPEED
	add_child(bullet)
