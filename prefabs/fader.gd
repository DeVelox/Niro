extends Area2D
@export var fade_in: TileMap
@export var fade_out: TileMap


func _ready() -> void:
	_toggle_layers(fade_in, false)


func _fade_in() -> void:
	_toggle_layers(fade_in, true)
	get_tree().call_group.call_deferred("fade_in", "fade_in", fade_in)


func _fade_out() -> void:
	get_tree().call_group("fade_out", "fade_out", fade_out)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		_fade_in()
		_fade_out()
		queue_free()


func _toggle_layers(tilemap: TileMap, state: bool) -> void:
	for i in tilemap.get_layers_count():
		tilemap.set_layer_enabled(i, state)
