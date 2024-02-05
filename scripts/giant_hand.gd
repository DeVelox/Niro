extends Node2D

@export_range(0, 280) var reach: float = 200
@export_enum("grab", "slap", "slam") var mode: String = "grab"
@export var delay: int = 10
@export var interval: int = 10
@export var repeat: bool = false
@export var flip: bool

@onready var container: Node2D = $"."
@onready var giant_hand: StaticBody2D = $GiantHand
@onready var hand: AnimatedSprite2D = $GiantHand/Hand
@onready var kill_zone: CollisionShape2D = $GiantHand/KillZone/CollisionShape2D
@onready var collision: CollisionPolygon2D = $GiantHand/CollisionPolygon2D
@onready var collision_slam: CollisionPolygon2D = $GiantHand/KillZone/CollisionPolygon2D

@onready var timer: Timer = $Timer


func _ready() -> void:
	giant_hand.hide()
	if mode:
		hand.animation = mode
		if mode == "grab":
			kill_zone.disabled = false
		elif mode == "slap":
			collision.disabled = false
		elif mode == "slam":
			collision_slam.disabled = false
			_double_slam()
			return
	if delay:
		timer.start(delay)
	if flip:
		container.scale.x = -1
	if repeat:
		timer.wait_time = interval
		timer.one_shot = false


func _attack() -> void:
	var orig_pos := Vector2(-300, 130)
	var new_pos := Vector2(reach, 180)
	giant_hand.position = orig_pos
	giant_hand.rotation_degrees = 30
	_hand_swipe(orig_pos, new_pos)


func _hand_swipe(orig_pos: Vector2, new_pos: Vector2) -> void:
	giant_hand.show()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(giant_hand, "position", new_pos, 1.0)
	tween.parallel().tween_property(giant_hand, "rotation_degrees", 15, 1.0)
	tween.parallel().tween_property(hand, "frame", 4, 1.0).set_delay(0.3)
	tween.parallel().tween_property(kill_zone, "disabled", false, 0.0).set_delay(1.0)
	tween.tween_property(kill_zone, "disabled", true, 1.0)
	tween.parallel().tween_property(giant_hand, "position", orig_pos, 1.0).set_delay(0.7)
	tween.parallel().tween_property(giant_hand, "rotation_degrees", 30, 1.0).set_delay(0.3)


func _double_slam() -> void:
	var orig_pos := Vector2(-300, 130)
	var orig_pos2 := Vector2(940, 130)
	var new_pos := Vector2(-60, 280)
	var new_pos2 := Vector2(700, 280)
	var slide_pos := Vector2(100, 280)
	var slide_pos2 := Vector2(540, 280)
	var second_hand := giant_hand.duplicate()
	giant_hand.rotation_degrees = 15
	second_hand.rotation_degrees = -15
	second_hand.scale.x = -1
	second_hand.position.x += 640
	container.add_child(second_hand)
	giant_hand.show()
	second_hand.show()
	var tween := create_tween()
	tween.tween_property(giant_hand, "position", new_pos, 1.0).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(second_hand, "position", new_pos2, 1.0).set_trans(
		Tween.TRANS_ELASTIC
	)
	tween.tween_property(giant_hand, "position", slide_pos, 0.5).set_trans(Tween.TRANS_BOUNCE)
	tween.parallel().tween_property(second_hand, "position", slide_pos2, 0.5).set_trans(
		Tween.TRANS_BOUNCE
	)
	tween.tween_property(giant_hand, "position", orig_pos, 1.5).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(second_hand, "position", orig_pos2, 1.5).set_trans(
		Tween.TRANS_ELASTIC
	)


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		Sound.sfx(Sound.SPIKE_HIT)
		body.kill()
