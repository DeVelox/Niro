class_name Bullet extends RigidBody2D

var direction := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_and_collide(direction * delta)


func _on_body_entered(body: Node) -> void:
	if body.has_method("try_recall"):
		body.try_recall()
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
