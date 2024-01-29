extends Node2D


func fade_out(tilemap: TileMap) -> void:
	var pos: Vector2i = tilemap.local_to_map(position)
	var tile: Vector2i = tilemap.get_cell_atlas_coords(1, pos)
	var anim: Vector2i = Scene.get_anim(tile, "out")
	if anim != tile:
		tilemap.set_cell(1, pos, 4, anim)
	else:
		tilemap.set_cell(1, pos, 2, tile)
	await get_tree().create_timer(1).timeout
	tilemap.erase_cell(1, pos)
