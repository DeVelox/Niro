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

	var anim: String
	if is_recall:
		anim = "fade_out"
	else:
		anim = "fade_in"

	get_tree().call_group("fade_in", anim, tilemap)


func fade_out(tilemap: TileMap, is_recall: bool = false) -> void:
	if not tilemap:
		return
	toggle_layers(tilemap, false)

	var anim: String
	if is_recall:
		anim = "fade_in"
	else:
		anim = "fade_out"

	get_tree().call_group("stay", "stay", tilemap)
	get_tree().call_group("fade_out", anim, tilemap)


func toggle_layers(tilemap: TileMap, state: bool) -> void:
	for i in [1, 2, 3]:
		tilemap.set_layer_enabled(i, state)


func recall(tilemap_count) -> void:
	if not tilemap_count:
		reload()
		return
	active_tilemap.reverse()
	for tilemap in active_tilemap:
		if not tilemap.prev:
			break
		_recall_out(tilemap)
		await _recall_in(tilemap.prev)
	active_tilemap.clear()
	reload()


func reload() -> void:
	var main := get_node("/root/Main")
	var load_level: Node2D = load(current_scene).instantiate()
	current_level.destroy()
	main.add_child(load_level)
	current_level = load_level


func _recall_in(tilemap: TileMap) -> void:
	fade_out(tilemap, true)
	await get_tree().create_timer(1).timeout


func _recall_out(tilemap: TileMap) -> void:
	fade_in(tilemap, true)


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
