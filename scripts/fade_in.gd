extends Node2D


func fade_in(tilemap: TileMap) -> void:
	Scene.toggle_layers(tilemap, true)
	var pos: Vector2i = tilemap.local_to_map(position)
	var tile: Vector2i = tilemap.get_cell_atlas_coords(1, pos)
	var anim: Vector2i = Scene.get_anim(tile, "in")
	if anim != tile:
		tilemap.set_cell(1, pos, 3, anim)
	else:
		tilemap.set_cell(1, pos, 2, tile)
	await get_tree().create_timer(1).timeout
	tilemap.set_cell(1, pos, 2, tile)
