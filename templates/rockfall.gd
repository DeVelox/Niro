extends Area2D

func _on_body_entered(_body):
	var rock = load("res://templates/rock.tscn").instantiate()
	rock.position.y -= 100
	call_deferred("add_child", rock)
