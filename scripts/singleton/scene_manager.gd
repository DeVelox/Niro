extends Node

signal should_fade(tilemap: TileMap)
signal active_tilemap_changed

enum Source { TILE = 7, FADEIN = 8, FADEOUT = 9 }

var current_scene: String
var current_level: Node2D

var spawn_point: Vector2

var active_tilemap: Array[TileMap]


func get_anim(tile: Vector2i) -> Vector2i:
	return tile


func fade_in(tilemap: TileMap, is_recall: bool = false) -> void:
	if not tilemap:
		return
	toggle_layers(tilemap, false)
	var temp_layer = _add_temp_layer(tilemap)

	var anim: String
	if is_recall:
		anim = "fade_out"
	else:
		anim = "fade_in"

	get_tree().call_group("fade_in", anim, tilemap, temp_layer)
	await get_tree().create_timer(1).timeout

	if is_instance_valid(tilemap):
		_remove_temp_layer(tilemap, temp_layer)
		toggle_layers(tilemap, true)


func fade_out(tilemap: TileMap, is_recall: bool = false) -> void:
	if not tilemap:
		return
	toggle_layers(tilemap, false)
	var temp_layer = _add_temp_layer(tilemap)

	var anim: String
	if is_recall:
		anim = "fade_in"
	else:
		anim = "fade_out"

	get_tree().call_group("stay", "stay", tilemap, temp_layer)
	get_tree().call_group("fade_out", anim, tilemap, temp_layer)
	await get_tree().create_timer(1).timeout

	if is_instance_valid(tilemap):
		_remove_temp_layer(tilemap, temp_layer)


func toggle_layers(tilemap: TileMap, state: bool) -> void:
	for i in [1, 2, 3]:
		tilemap.set_layer_enabled(i, state)


func fade_animation(
	tilemap: TileMap, layer: int, position: Vector2, source: int, temp_layer: int
) -> void:
	var pos: Vector2i = tilemap.local_to_map(position)
	var tile: Vector2i = tilemap.get_cell_atlas_coords(layer, pos)
	var anim: Vector2i = Scene.get_anim(tile)
	#tilemap.get_cell_tile_data(layer, anim).flip_h = tilemap.get_cell_tile_data(layer, tile).flip_h
	if source == Source.TILE:
		tilemap.set_cell(temp_layer, pos, source, tile)
	else:
		tilemap.set_cell(temp_layer, pos, source, anim)


func _add_temp_layer(tilemap: TileMap) -> int:
	var layer := tilemap.get_layers_count()
	tilemap.add_layer(-1)
	tilemap.set_layer_enabled(layer, true)
	return layer


func _remove_temp_layer(tilemap: TileMap, layer: int) -> void:
	if tilemap.get_layers_count() > layer:
		tilemap.remove_layer(layer)


func recall():
	active_tilemap.reverse()
	for tilemap in active_tilemap:
		if not tilemap.prev:
			break
		_recall_out(tilemap)
		await _recall_in(tilemap.prev)
	active_tilemap.clear()
	reload()


func reload():
	var main := get_node("/root/Main")
	var load_level: Node2D = load(current_scene).instantiate()
	main.add_child(load_level)
	current_level.queue_free()
	current_level = load_level


func _recall_in(tilemap: TileMap):
	await fade_out(tilemap, true)


func _recall_out(tilemap: TileMap):
	await fade_in(tilemap, true)


func generate_static_to_animated_map(tilemap: TileMap) -> Dictionary:
	# Get all static tiles
	var static_atlas := _get_atlas_coords_for_all_tiles(tilemap, 0)
	# Get all animated tiles
	var animated_atlas := _get_atlas_coords_for_all_tiles(tilemap, 1)

	var map: Dictionary = {}
	for i in static_atlas.size():
		map[static_atlas[i]] = animated_atlas[i]
	return map


func _get_atlas_coords_for_all_tiles(tilemap: TileMap, layer: int) -> Array[Vector2i]:
	var atlas: Array[Vector2i] = []
	var tiles = tilemap.get_used_cells(1)
	for i in tiles:
		atlas.append(tilemap.get_cell_atlas_coords(layer, i))
	return atlas


func pause_animation(tilemap: TileMap, source: Source) -> void:
	var atlas: TileSetAtlasSource = tilemap.tile_set.get_source(source)
	for i in atlas.get_tiles_count():
		atlas.set_tile_animation_frame_duration(atlas.get_tile_id(i), 0, INF)


func resume_animation(tilemap: TileMap, source: Source) -> void:
	var atlas: TileSetAtlasSource = tilemap.tile_set.get_source(source)
	for i in atlas.get_tiles_count():
		atlas.set_tile_animation_frame_duration(atlas.get_tile_id(i), 0, 1)
