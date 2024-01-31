extends Area2D
const ROCK = preload("res://prefabs/utility library/rock.tscn")


func _on_body_entered(_body: Node) -> void:
	var rock: Rock = ROCK.instantiate()
	rock.position.y -= 100
	add_child(rock)
