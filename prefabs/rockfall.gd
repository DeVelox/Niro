extends Area2D


func _on_body_entered(_body: Node) -> void:
	var rock: Rock = load("res://prefabs/rock.tscn").instantiate()
	rock.position.y -= 100
	call_deferred("add_child", rock)
