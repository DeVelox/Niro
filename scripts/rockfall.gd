extends Area2D


func _on_body_entered(_body: Node) -> void:
	var rock: Rock = load("res://prefabs/utility library/rock.tscn").instantiate()
	rock.position.y -= 100
	add_child.call_deferred(rock)
