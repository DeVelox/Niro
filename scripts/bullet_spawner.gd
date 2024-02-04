extends Node2D

const BULLET = preload("res://prefabs/utility library/bullet.tscn")
const BULLET_SPEED = 400
const STARTING_ANGLE = 0

@export var delay: float = 1.5
@export var point: Vector2
@export var angle: float = STARTING_ANGLE
@export var bullet_count: int = 4
@export var groups: int = 3
@export var speed_variant_array: Array[int] = [0, 80, 50, -20]
@export_enum("half_circle", "circle") var shape: String = "half_circle"
@export_enum("shotgun", "single", "barrage") var mode: String = "shotgun"
@export var barrage_wait_time: float = 0.15
@export var bullet_spread: int = 5

@onready var timer: Timer = $Timer
@onready var bullet_spawner: Node2D = $"."
@onready var target: CollisionShape2D = $Target


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(delay)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _shoot_barrage(shot_angle: float, barrage_count: int) -> void:
	for count in barrage_count:
		var bullet: Bullet = BULLET.instantiate()
		var direction := _get_direction(shot_angle)
		bullet.direction = direction * BULLET_SPEED
		add_child(bullet)
		shot_angle = _get_next_step(shot_angle)
		await get_tree().create_timer(barrage_wait_time).timeout


func _shoot_single(shot_angle: float) -> void:
	var bullet: Bullet = BULLET.instantiate()
	var direction := _get_direction(shot_angle)
	bullet.direction = direction * BULLET_SPEED
	add_child(bullet)


func _shoot_shotgun(shot_angle: float, pellet_count: int, speed_variant_array: Array[int]) -> void:
	var angle_diff: float = 2 * PI / (bullet_spread * (groups - 1))
	shot_angle -= angle_diff * pellet_count / 2
	for count in pellet_count:
		var direction := _get_direction(shot_angle)
		var bullet: Bullet = BULLET.instantiate()
		bullet.direction = direction * (BULLET_SPEED - speed_variant_array[count])
		add_child(bullet)
		shot_angle += angle_diff


func _get_direction(current_angle: float) -> Vector2:
	var x: float = cos(current_angle)
	var y: float = sin(current_angle)
	if shape == "half_circle":
		x = cos(current_angle)
		y = sin(current_angle) if sin(current_angle) > 0 else -sin(current_angle)
	elif shape == "circle":
		x = cos(current_angle)
		y = sin(current_angle)
	return Vector2(x, y)


func _get_next_step(curren_angle: float) -> float:
	var new_angle: float = curren_angle
	new_angle += 2 * PI / (bullet_spread * (groups - 1))
	return new_angle


func _on_timer_timeout() -> void:
	target.position = _get_direction(angle) * 100
	if mode == "barrage":
		_shoot_barrage(angle, bullet_count)
	elif mode == "shotgun":
		_shoot_shotgun(angle, bullet_count, speed_variant_array)
	elif mode == "single":
		_shoot_single(angle)
	angle += 2 * PI / (groups + 1)
