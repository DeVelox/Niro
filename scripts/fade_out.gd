extends Node2D


func fade_out(tilemap: TileMap) -> void:
	tilemap.set_layer_enabled(1, false)
	var pos: Vector2 = tilemap.local_to_map(position)
	var tile: Vector2i = tilemap.get_cell_atlas_coords(1, pos)
	tilemap.set_cell(3, pos, 4, Scene.get_anim(tile, "out"))
	await get_tree().create_timer(1).timeout
	for i in tilemap.get_layers_count():
		tilemap.erase_cell(i, pos)
