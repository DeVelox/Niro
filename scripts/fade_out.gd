extends Node2D


func fade_out(tilemap: TileMap) -> void:
	var vision = Upgrades.check(Upgrades.Type.VISION)
	if vision:
		_fade(tilemap, 2)
	_fade(tilemap, 1)


func _fade(tilemap: TileMap, layer: int) -> void:
	var pos: Vector2i = tilemap.local_to_map(position)
	var tile: Vector2i = tilemap.get_cell_atlas_coords(layer, pos)
	var anim: Vector2i = Scene.get_anim(tile, "out")
	if anim != tile:
		tilemap.set_cell(layer, pos, 4, anim)
	else:
		tilemap.set_cell(layer, pos, 2, tile)
	await get_tree().create_timer(1).timeout
	tilemap.set_cell(layer, pos, 2, tile)
