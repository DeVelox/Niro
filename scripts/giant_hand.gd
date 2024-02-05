extends Node2D

@export_range(0, 280) var reach: float = 200
@export_enum("grab", "slap") var mode: String = "grab"
@export var flip: bool

@onready var container: Node2D = $"."
@onready var giant_hand: StaticBody2D = $GiantHand
@onready var hand: AnimatedSprite2D = $GiantHand/Hand
@onready var kill_zone: CollisionShape2D = $GiantHand/KillZone/CollisionShape2D
@onready var collision: CollisionPolygon2D = $GiantHand/CollisionPolygon2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if mode:
		hand.animation = mode
		if mode == "grab":
			collision.disabled = true
	if flip:
		container.scale.x = -1

	var tween = create_tween()
	var orig_pos := Vector2(-300, -50)
	var new_pos := Vector2(reach, 0)
	giant_hand.position = orig_pos
	giant_hand.rotation_degrees = 30

	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(giant_hand, "position", new_pos, 1.0)
	tween.parallel().tween_property(giant_hand, "rotation_degrees", 15, 1.0)
	tween.parallel().tween_property(hand, "frame", 4, 1.0).set_delay(0.3)
	tween.parallel().tween_property(kill_zone, "disabled", false, 0.0).set_delay(1.0)
	tween.tween_property(kill_zone, "disabled", true, 1.0)
	tween.parallel().tween_property(giant_hand, "position", orig_pos, 1.0).set_delay(0.7)
	tween.parallel().tween_property(giant_hand, "rotation_degrees", 30, 1.0).set_delay(0.3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		Sound.sfx(Sound.SPIKE_HIT)
		body.kill()
