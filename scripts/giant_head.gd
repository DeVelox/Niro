extends Node2D

@onready var giant_head: StaticBody2D = $GiantHead
@onready var head: AnimatedSprite2D = $GiantHead/AnimatedSprite2D
@onready var bullet_spawner: Marker2D = $GiantHead/BulletSpawner
@onready var animation_player: AnimationPlayer = $GiantHead/AnimationPlayer


func _ready() -> void:
	pass


func animation() -> void:
	animation_player.play("start")


func fight() -> void:
	var come_down := Vector2(320, 60)
	var go_away_now := Vector2(320, -160)
	var tween := create_tween()
	# I don't know how to make this simpler right now, pretty much have to hard code phases
	tween.tween_property(giant_head, "position", come_down, 1.0)
	tween.tween_callback(head.play.bind("open")).set_delay(0.5)
	tween.tween_callback(head.play.bind("close")).set_delay(0.5)
	tween.tween_callback(head.play.bind("open")).set_delay(1.5)
	tween.parallel().tween_property(bullet_spawner, "delay", 1.5, 0.0)
	tween.tween_property(bullet_spawner, "mode", "barrage", 0.0).set_delay(5)
	tween.tween_callback(head.play.bind("close")).set_delay(5)
	tween.tween_property(giant_head, "position", go_away_now, 1.0)
	tween.tween_property(bullet_spawner, "delay", 0.0, 0.0)
