extends Node2D
	
func fade_out(tilemap: TileMap) -> void:
	var pos: Vector2 = tilemap.local_to_map(position)
	tilemap.set_cell(1, pos, 0, Vector2i(12,0))
	await get_tree().create_timer(1).timeout
	tilemap.erase_cell(1, pos)
	tilemap.erase_cell(2, pos)
