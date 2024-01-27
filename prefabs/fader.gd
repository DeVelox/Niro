extends Area2D
@export var fade_in: TileMap
@export var fade_out: TileMap


func _ready() -> void:
	fade_in.modulate = Color(1, 1, 1, 0)
	for i in fade_in.get_layers_count():
		fade_in.set_layer_enabled(i, false)


func _fade_in() -> void:
	var tween = create_tween()
	for i in fade_in.get_layers_count():
		tween.tween_callback(fade_in.set_layer_enabled.bind(i, true))
	tween.tween_property(fade_in, "modulate", Color(1, 1, 1, 1), 1)


func _fade_out() -> void:
	get_tree().call_group("fade_out", "fade_out", fade_out)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		_fade_in()
		_fade_out()
