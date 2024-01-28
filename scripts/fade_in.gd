extends Node2D


func fade_in(tilemap: TileMap) -> void:
	Scene.toggle_layers(tilemap, true)
	tilemap.set_layer_enabled(1, false)
	var pos: Vector2 = tilemap.local_to_map(position)
	var tile: Vector2i = tilemap.get_cell_atlas_coords(1, pos)
	tilemap.set_cell(3, pos, 3, Scene.get_anim(tile, "in"))
	await get_tree().create_timer(1).timeout
	tilemap.set_layer_enabled(1, true)
	for i in tilemap.get_used_cells(3):
		tilemap.erase_cell(3, i)
