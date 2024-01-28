extends Node


func fade_in(tilemap: TileMap) -> void:
	toggle_layers(tilemap, true)
	get_tree().call_group.call_deferred("fade_in", "fade_in", tilemap)


func fade_out(tilemap: TileMap) -> void:
	get_tree().call_group("fade_out", "fade_out", tilemap)


func toggle_layers(tilemap: TileMap, state: bool) -> void:
	for i in tilemap.get_layers_count():
		tilemap.set_layer_enabled(i, state)
