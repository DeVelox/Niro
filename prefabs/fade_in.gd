extends Node2D


func fade_in(tilemap: TileMap) -> void:
	var pos: Vector2 = tilemap.local_to_map(position)
	var tile: Vector2i = tilemap.get_cell_atlas_coords(1, pos)
	tilemap.set_cell(1, pos, 0, Vector2i(12, 0))
	await get_tree().create_timer(1).timeout
	tilemap.set_cell(1, pos, 0, tile)
