extends Node2D

var come_down := Vector2(320, 60)
var go_away_now := Vector2(320, -160)

@onready var giant_head: StaticBody2D = $GiantHead
@onready var head: AnimatedSprite2D = $GiantHead/AnimatedSprite2D
@onready var bullet_spawner: Marker2D = $GiantHead/BulletSpawner


func _ready() -> void:
	var tween := create_tween()
	phase1(tween)
	phase2(tween)


func phase1(tween: Tween) -> void:
	var come_down := Vector2(320, 60)
	var go_away_now := Vector2(320, -160)
	# Head comes down, and roars which lines up with fader dropping the player down
	tween.tween_property(giant_head, "position", come_down, 1.0)
	tween.tween_property(head, "animation", &"open", 0.0)
	tween.tween_property(head, "frame", 9, 1.0)  # change this
	tween.tween_property(head, "animation", &"roar", 0.0)
	tween.tween_property(head, "frame", 4, 1.0)  # or this
	tween.tween_property(head, "animation", &"close", 0.0)
	tween.tween_property(head, "frame", 9, 1.0)  # or this to sync up with falling
	tween.tween_property(head, "animation", &"idle", 0.0)
	tween.tween_property(head, "animation", &"open", 0.0).set_delay(1.5)  # no touchy
	tween.parallel().tween_property(bullet_spawner, "delay", 1.5, 0.0).set_delay(1.0)  # no touchy
	tween.tween_property(bullet_spawner, "mode", "barrage", 0.0).set_delay(5)  # duration of shotgun
	tween.tween_callback(head.play.bind("close")).set_delay(5)  # duration of barrage
	tween.tween_property(bullet_spawner, "delay", 0.0, 0.0)
	tween.tween_property(head, "animation", &"roar", 0.0)
	tween.tween_property(head, "frame", 4, 1.0)
	tween.tween_property(head, "animation", &"idle", 0.0)


func phase2(tween: Tween) -> void:
	tween.tween_property(head, "animation", &"roar", 0.0).set_delay(0.5)
	tween.tween_property(bullet_spawner, "delay", 0.1, 0.0)
	tween.tween_property(bullet_spawner, "mode", "single", 0.0)
	tween.tween_property(bullet_spawner, "groups", 12, 0.0)
	tween.tween_callback(head.play.bind("close")).set_delay(5)
	tween.tween_property(bullet_spawner, "delay", 0.0, 0.0)
	tween.tween_property(head, "animation", &"idle", 0.0)
	tween.tween_property(head, "animation", &"open", 0.0).set_delay(5)  # waiting for arm
	tween.tween_property(head, "frame", 9, 1.0)
	tween.tween_property(head, "animation", &"roar", 0.0)
	tween.tween_property(head, "frame", 4, 1.0)
	tween.tween_property(head, "animation", &"close", 0.0)
	tween.tween_property(head, "frame", 9, 1.0)
	tween.tween_property(head, "animation", &"idle", 0.0)
	tween.tween_property(head, "animation", &"open", 0.0).set_delay(1.5)  # no touchy
	tween.parallel().tween_property(bullet_spawner, "delay", 1.5, 0.0).set_delay(1.0)
	tween.tween_property(bullet_spawner, "mode", "shotgun", 0.0)
	tween.tween_property(bullet_spawner, "groups", 4, 0.0)
	tween.tween_callback(head.play.bind("close")).set_delay(5)  # final shooting
	tween.tween_property(giant_head, "position", go_away_now, 1.0)
	tween.tween_property(bullet_spawner, "delay", 0.0, 0.0)
	# Another roar which lines up with the level switch and platform animation

	# Boss does another shooting pattern

	# Boss stops shooting for arm to come in

	# Boss shoots again
