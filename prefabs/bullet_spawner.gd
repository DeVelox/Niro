extends Node2D

const BULLET = preload("res://prefabs/bullet.tscn")
const BULLET_SPEED = 500

@export var delay: float = 1

@onready var timer: Timer = $Timer
@onready var bullet_spawner: Node2D = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start(delay)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var bullet: Bullet = BULLET.instantiate()
	var player: Player = get_node("/root/Main/Player")
	var direction := player.global_position - bullet_spawner.global_position
	bullet.direction = direction.normalized() * BULLET_SPEED
	add_child(bullet)
