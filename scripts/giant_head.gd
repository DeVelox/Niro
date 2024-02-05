extends Node2D

@onready var giant_head: StaticBody2D = $GiantHead
@onready var head: AnimatedSprite2D = $GiantHead/AnimatedSprite2D
@onready var bullet_spawner: Marker2D = $GiantHead/BulletSpawner
@onready var animation_player: AnimationPlayer = $GiantHead/AnimationPlayer


func _ready() -> void:
	pass


func animation() -> void:
	animation_player.play("start")

func phase1() -> void:
	var come_down := Vector2(320, 60)
	var go_away_now := Vector2(320, -160)
	var tween := create_tween()
	# Head comes down, and roars which lines up with fader dropping the player down
	tween.tween_property(giant_head, "position", come_down, 1.0)
	tween.tween_callback(head.play.bind("open")).set_delay(0.5)
	tween.tween_callback(head.play.bind("close")).set_delay(0.5)
	tween.tween_callback(head.play.bind("open")).set_delay(1.5)
	# After delay for all the platform to spawn the boss start shooting stuff
	tween.parallel().tween_property(bullet_spawner, "delay", 1.5, 0.0)
	tween.tween_property(bullet_spawner, "mode", "barrage", 0.0).set_delay(5)
	# change up shooting pattern
	tween.tween_callback(head.play.bind("close")).set_delay(5)
	tween.tween_property(giant_head, "position", go_away_now, 1.0)
	tween.tween_property(bullet_spawner, "delay", 0.0, 0.0)
	
func phase2() -> void:
	# Another roar which lines up with the level switch and platform animation
	
	# Boss does another shooting pattern
	
	# Boss stops shooting for arm to come in
	
	# Boss shoots again
