extends Node2D

const BULLET = preload("res://prefabs/utility library/bullet.tscn")
const BULLET_SPEED = 400

@export var delay: float = 1.5

var point: Vector2
var i: float = 0
var bullet_count: int = 4
var groups: int = 3
var step: float = PI / (bullet_count * groups - 1)
var speed_variant_array = [0, 80, 50, -20]

@onready var timer: Timer = $Timer
@onready var bullet_spawner: Node2D = $"."
@onready var target: CollisionShape2D = $Target


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(delay)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	if i > PI:
		i = 0
	for count in range(0, bullet_count):
		var x: float = cos(i)
		var y: float = sin(i) if sin(i) > 0 else -sin(i)
		var direction := Vector2(x, y)
		var bullet: Bullet = BULLET.instantiate()
		bullet.direction = direction * (BULLET_SPEED - speed_variant_array[count])
		target.position = direction * 100
		add_child(bullet)
		i += step
