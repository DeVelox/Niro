extends Area2D

var exploded := false

@onready var explosion: Area2D = $"."
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass


func _on_body_entered(_body) -> void:
	if not exploded:
		scale *= 1.5
		timer.start()


func _on_timer_timeout() -> void:
	if not exploded:
		exploded = true
		scale *= 2
		for body in explosion.get_overlapping_bodies():
			if body.is_in_group("players"):
				body.velocity = (
					(body.global_position - explosion.global_position).normalized() * 1000
				)
