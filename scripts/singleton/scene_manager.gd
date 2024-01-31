extends Node

signal destroy
signal should_fade(tilemap: TileMap)

enum Source {TILE = 2, FADEIN = 5, FADEOUT = 6}

var current_scene: String
var current_level: Node2D
var scene_history: Array[String]

var spawn_point: Vector2
var fade_map: Dictionary = {
	Vector2i(2, 5): Vector2i(0, 0),
	Vector2i(3, 5): Vector2i(0, 0),
	Vector2i(4, 5): Vector2i(0, 0),
	Vector2i(5, 5): Vector2i(0, 0),
	Vector2i(6, 5): Vector2i(0, 0),
	Vector2i(8, 5): Vector2i(0, 0),
	Vector2i(9, 5): Vector2i(0, 0),
	Vector2i(10, 5): Vector2i(0, 0),
	Vector2i(11, 5): Vector2i(0, 0),
	Vector2i(12, 5): Vector2i(0, 0),
	Vector2i(8, 6): Vector2i(0, 0),
	Vector2i(9, 6): Vector2i(0, 0),
	Vector2i(10, 6): Vector2i(0, 0),
	Vector2i(11, 6): Vector2i(0, 0),
	Vector2i(12, 6): Vector2i(0, 0),
	Vector2i(14, 4): Vector2i(0, 0),
	Vector2i(14, 5): Vector2i(0, 0),
	Vector2i(14, 6): Vector2i(0, 0),
	Vector2i(14, 7): Vector2i(0, 0),
	Vector2i(14, 8): Vector2i(0, 0),
	Vector2i(15, 8): Vector2i(0, 0),
	Vector2i(16, 8): Vector2i(0, 0),
	Vector2i(17, 8): Vector2i(0, 0),
	Vector2i(18, 8): Vector2i(0, 0),
	Vector2i(18, 7): Vector2i(0, 0),
	Vector2i(18, 6): Vector2i(0, 0),
	Vector2i(18, 5): Vector2i(0, 0),
	Vector2i(18, 4): Vector2i(0, 0),
	Vector2i(17, 4): Vector2i(0, 0),
	Vector2i(16, 4): Vector2i(0, 0),
	Vector2i(15, 4): Vector2i(0, 0),
	Vector2i(21, 4): Vector2i(0, 0),
	Vector2i(21, 5): Vector2i(0, 0),
	Vector2i(21, 6): Vector2i(0, 0),
	Vector2i(21, 7): Vector2i(0, 0),
	Vector2i(21, 8): Vector2i(0, 0),
	Vector2i(22, 8): Vector2i(0, 0),
	Vector2i(23, 8): Vector2i(0, 0),
	Vector2i(24, 8): Vector2i(0, 0),
	Vector2i(25, 8): Vector2i(0, 0),
	Vector2i(25, 7): Vector2i(0, 0),
	Vector2i(25, 6): Vector2i(0, 0),
	Vector2i(25, 5): Vector2i(0, 0),
	Vector2i(25, 4): Vector2i(0, 0),
	Vector2i(24, 4): Vector2i(0, 0),
	Vector2i(23, 4): Vector2i(0, 0),
	Vector2i(22, 4): Vector2i(0, 0),
	Vector2i(2, 9): Vector2i(0, 0),
	Vector2i(3, 9): Vector2i(0, 0),
	Vector2i(4, 9): Vector2i(0, 0),
	Vector2i(5, 9): Vector2i(0, 0),
	Vector2i(6, 9): Vector2i(0, 0),
	Vector2i(8, 9): Vector2i(0, 0),
	Vector2i(9, 9): Vector2i(0, 0),
	Vector2i(10, 9): Vector2i(0, 0),
	Vector2i(11, 9): Vector2i(0, 0),
	Vector2i(12, 9): Vector2i(0, 0),
	Vector2i(9, 17): Vector2i(0, 0),
	Vector2i(9, 16): Vector2i(0, 0),
	Vector2i(9, 15): Vector2i(0, 0),
	Vector2i(9, 14): Vector2i(0, 0),
	Vector2i(9, 13): Vector2i(0, 0),
	Vector2i(9, 11): Vector2i(0, 0),
	Vector2i(9, 12): Vector2i(0, 0),
	Vector2i(11, 11): Vector2i(0, 0),
	Vector2i(11, 12): Vector2i(0, 0),
	Vector2i(11, 13): Vector2i(0, 0),
	Vector2i(13, 11): Vector2i(0, 0),
	Vector2i(13, 12): Vector2i(0, 0),
	Vector2i(13, 13): Vector2i(0, 0),
	Vector2i(20, 11): Vector2i(0, 0),
	Vector2i(20, 12): Vector2i(0, 0),
	Vector2i(20, 13): Vector2i(0, 0),
	Vector2i(20, 14): Vector2i(0, 0),
	Vector2i(20, 15): Vector2i(0, 0),
	Vector2i(20, 16): Vector2i(0, 0),
	Vector2i(20, 17): Vector2i(0, 0),
	Vector2i(22, 11): Vector2i(0, 0),
	Vector2i(22, 12): Vector2i(0, 0),
	Vector2i(22, 13): Vector2i(0, 0),
	Vector2i(24, 11): Vector2i(0, 0),
	Vector2i(24, 12): Vector2i(0, 0),
	Vector2i(24, 13): Vector2i(0, 0),
	Vector2i(16, 14): Vector2i(0, 0),
	Vector2i(17, 14): Vector2i(0, 0),
	Vector2i(16, 16): Vector2i(0, 0),
	Vector2i(17, 16): Vector2i(0, 0),
	Vector2i(18, 16): Vector2i(0, 0),
	Vector2i(2, 4): Vector2i(1, 0),
	Vector2i(3, 4): Vector2i(1, 0),
	Vector2i(4, 4): Vector2i(1, 0),
	Vector2i(5, 4): Vector2i(1, 0),
	Vector2i(6, 4): Vector2i(1, 0),
	Vector2i(8, 4): Vector2i(1, 0),
	Vector2i(9, 4): Vector2i(1, 0),
	Vector2i(10, 4): Vector2i(1, 0),
	Vector2i(11, 4): Vector2i(1, 0),
	Vector2i(12, 4): Vector2i(1, 0),
	Vector2i(15, 5): Vector2i(1, 0),
	Vector2i(16, 5): Vector2i(1, 0),
	Vector2i(17, 5): Vector2i(1, 0),
	Vector2i(17, 6): Vector2i(1, 0),
	Vector2i(16, 6): Vector2i(1, 0),
	Vector2i(15, 6): Vector2i(1, 0),
	Vector2i(15, 7): Vector2i(1, 0),
	Vector2i(16, 7): Vector2i(1, 0),
	Vector2i(17, 7): Vector2i(1, 0),
	Vector2i(22, 5): Vector2i(1, 0),
	Vector2i(23, 5): Vector2i(1, 0),
	Vector2i(24, 5): Vector2i(1, 0),
	Vector2i(24, 6): Vector2i(1, 0),
	Vector2i(-1, -1): Vector2i(1, 0),
	Vector2i(22, 6): Vector2i(1, 0),
	Vector2i(22, 7): Vector2i(1, 0),
	Vector2i(23, 7): Vector2i(1, 0),
	Vector2i(24, 7): Vector2i(1, 0),
	Vector2i(2, 8): Vector2i(1, 0),
	Vector2i(3, 8): Vector2i(1, 0),
	Vector2i(4, 8): Vector2i(1, 0),
	Vector2i(5, 8): Vector2i(1, 0),
	Vector2i(6, 8): Vector2i(1, 0),
	Vector2i(8, 8): Vector2i(1, 0),
	Vector2i(9, 8): Vector2i(1, 0),
	Vector2i(10, 8): Vector2i(1, 0),
	Vector2i(11, 8): Vector2i(1, 0),
	Vector2i(12, 8): Vector2i(1, 0),
	Vector2i(9, 10): Vector2i(1, 0),
	Vector2i(11, 10): Vector2i(1, 0),
	Vector2i(13, 10): Vector2i(1, 0),
	Vector2i(20, 10): Vector2i(1, 0),
	Vector2i(22, 10): Vector2i(1, 0),
	Vector2i(24, 10): Vector2i(1, 0),
	Vector2i(16, 13): Vector2i(1, 0),
	Vector2i(17, 13): Vector2i(1, 0),
	Vector2i(16, 15): Vector2i(1, 0),
	Vector2i(17, 15): Vector2i(1, 0),
	Vector2i(18, 15): Vector2i(1, 0),
	Vector2i(17, 11): Vector2i(1, 0),
	Vector2i(18, 11): Vector2i(1, 0),
	Vector2i(9, 21): Vector2i(0, 0),
	Vector2i(10, 21): Vector2i(0, 0),
	Vector2i(11, 21): Vector2i(0, 0),
	Vector2i(12, 21): Vector2i(0, 0),
	Vector2i(13, 21): Vector2i(0, 0),
	Vector2i(14, 21): Vector2i(0, 0),
	Vector2i(15, 21): Vector2i(0, 0),
	Vector2i(16, 21): Vector2i(0, 0),
	Vector2i(17, 21): Vector2i(0, 0),
	Vector2i(18, 21): Vector2i(0, 0),
	Vector2i(19, 21): Vector2i(0, 0),
	Vector2i(20, 21): Vector2i(0, 0),
	Vector2i(21, 21): Vector2i(0, 0),
	Vector2i(8, 20): Vector2i(1, 0),
	Vector2i(9, 20): Vector2i(1, 0),
	Vector2i(10, 20): Vector2i(1, 0),
	Vector2i(11, 20): Vector2i(1, 0),
	Vector2i(12, 20): Vector2i(1, 0),
	Vector2i(13, 20): Vector2i(1, 0),
	Vector2i(14, 20): Vector2i(1, 0),
	Vector2i(15, 20): Vector2i(1, 0),
	Vector2i(16, 20): Vector2i(1, 0),
	Vector2i(17, 20): Vector2i(1, 0),
	Vector2i(18, 20): Vector2i(1, 0),
	Vector2i(19, 20): Vector2i(1, 0),
	Vector2i(20, 20): Vector2i(1, 0),
	Vector2i(21, 20): Vector2i(1, 0),
	Vector2i(22, 20): Vector2i(1, 0),
	Vector2i(22, 21): Vector2i(1, 0),
	Vector2i(22, 22): Vector2i(1, 0),
	Vector2i(21, 22): Vector2i(1, 0),
	Vector2i(20, 22): Vector2i(1, 0),
	Vector2i(19, 22): Vector2i(1, 0),
	Vector2i(18, 22): Vector2i(1, 0),
	Vector2i(17, 22): Vector2i(1, 0),
	Vector2i(16, 22): Vector2i(1, 0),
	Vector2i(15, 22): Vector2i(1, 0),
	Vector2i(14, 22): Vector2i(1, 0),
	Vector2i(13, 22): Vector2i(1, 0),
	Vector2i(12, 22): Vector2i(1, 0),
	Vector2i(11, 22): Vector2i(1, 0),
	Vector2i(10, 22): Vector2i(1, 0),
	Vector2i(9, 22): Vector2i(1, 0),
	Vector2i(8, 22): Vector2i(1, 0),
	Vector2i(8, 21): Vector2i(1, 0)
}


func get_anim(tile: Vector2i) -> Vector2i:
	return fade_map.get(tile)


func generate_static_to_animated_map(tilemap: TileMap) -> Dictionary:
	# Get all static tiles
	var static_atlas := _get_atlas_coords_for_all_tiles(tilemap, 0)
	# Get all animated tiles
	var animated_atlas := _get_atlas_coords_for_all_tiles(tilemap, 1)

	var map: Dictionary = {}
	for i in static_atlas.size():
		map[static_atlas[i]] = animated_atlas[i]
	return map


func fade_in(tilemap: TileMap) -> void:
	toggle_layers(tilemap, false)
	var temp = _add_temp_layer(tilemap)

	get_tree().call_group("stay", "stay", tilemap, temp)
	get_tree().call_group("fade_in", "fade_in", tilemap, temp)
	await get_tree().create_timer(1).timeout

	_remove_temp_layer(tilemap, temp)
	toggle_layers(tilemap, true)


func fade_out(tilemap: TileMap) -> void:
	toggle_layers(tilemap, false)
	var temp = _add_temp_layer(tilemap)
	
	get_tree().call_group("stay", "stay", tilemap, temp)
	get_tree().call_group("fade_out", "fade_out", tilemap, temp)
	await get_tree().create_timer(1).timeout

	_remove_temp_layer(tilemap, temp)


func _add_temp_layer(tilemap: TileMap) -> int:
	var layer := tilemap.get_layers_count()
	tilemap.add_layer(-1)
	tilemap.set_layer_enabled(layer, true)
	return layer


func _remove_temp_layer(tilemap: TileMap, layer: int) -> void:
	tilemap.remove_layer(layer)


func toggle_layers(tilemap: TileMap, state: bool) -> void:
	for i in tilemap.get_layers_count():
		tilemap.set_layer_enabled(i, state)


func fade_animation(tilemap: TileMap, layer: int, position: Vector2, source: int, temp: int) -> void:
	var pos: Vector2i = tilemap.local_to_map(position)
	var tile: Vector2i = tilemap.get_cell_atlas_coords(layer, pos)
	var anim: Vector2i = Scene.get_anim(tile)
	if source == Source.TILE:
		tilemap.set_cell(temp, pos, source, tile)
	else:
		tilemap.set_cell(temp, pos, source, anim)

func _get_atlas_coords_for_all_tiles(tilemap: TileMap, layer: int) -> Array[Vector2i]:
	var atlas: Array[Vector2i] = []
	var tiles = tilemap.get_used_cells(1)
	for i in tiles:
		atlas.append(tilemap.get_cell_atlas_coords(layer, i))
	return atlas


func reload():
	var main := get_node("/root/Main")
	var load_level: Node2D = load(current_scene).instantiate()
	main.add_child(load_level)
	current_level.queue_free()
	current_level = load_level
