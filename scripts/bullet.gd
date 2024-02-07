class_name Bullet extends RigidBody2D

var direction := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_and_collide(direction * delta)


func _on_body_entered(body: Node) -> void:
	if body.has_method("damage"):
		Sound.sfx(Sound.ROCK_HIT)
		body.damage()
		queue_free()


func _on_body_exited(body: Node) -> void:
	if body.has_method("is_safe"):
		body.is_safe()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players") and Upgrades.check(Upgrades.Type.SLOWMO):
		Upgrades.use_slowmo()
		await get_tree().create_timer(1).timeout
		Upgrades.end_slowmo()
