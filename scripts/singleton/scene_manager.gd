extends Node

signal should_fade(tilemap: TileMap)
signal active_tilemap_changed

enum Source { TILE = 7, FADEIN = 8, FADEOUT = 9 }

var current_scene: String
var current_level: Node2D

var spawn_point: Vector2

var active_tilemap: Array[TileMap]

var attachments: Array[Vector2i] = [
	Vector2i(1, 2),
	Vector2i(1, 3),
	Vector2i(1, 4),
	Vector2i(1, 5),
	Vector2i(1, 6),
	Vector2i(1, 7),
	Vector2i(1, 8),
	Vector2i(1, 9),
	Vector2i(1, 10),
	Vector2i(1, 11),
	Vector2i(1, 12),
	Vector2i(1, 13),
	Vector2i(1, 14),
	Vector2i(1, 15),
	Vector2i(3, 2),
	Vector2i(3, 3),
	Vector2i(3, 4),
	Vector2i(3, 5),
	Vector2i(3, 6),
	Vector2i(3, 7),
	Vector2i(4, 2),
	Vector2i(4, 3),
	Vector2i(4, 4),
	Vector2i(4, 5),
	Vector2i(4, 6),
	Vector2i(4, 7),
	Vector2i(6, 2),
	Vector2i(6, 3),
	Vector2i(6, 4),
	Vector2i(6, 5),
	Vector2i(6, 6),
	Vector2i(6, 7),
	Vector2i(6, 8),
	Vector2i(6, 9),
	Vector2i(6, 10),
	Vector2i(6, 11),
	Vector2i(6, 12),
	Vector2i(6, 13),
	Vector2i(6, 14),
	Vector2i(6, 15),
	Vector2i(8, 6),
	Vector2i(8, 8),
	Vector2i(8, 10),
	Vector2i(8, 12),
	Vector2i(8, 13),
	Vector2i(9, 6),
	Vector2i(9, 8),
	Vector2i(9, 10),
	Vector2i(9, 12),
	Vector2i(9, 13),
	Vector2i(10, 6),
	Vector2i(10, 8),
	Vector2i(10, 10),
	Vector2i(10, 12),
	Vector2i(10, 13),
	Vector2i(11, 6),
	Vector2i(11, 8),
	Vector2i(11, 10),
	Vector2i(11, 12),
	Vector2i(11, 13),
	Vector2i(12, 6),
	Vector2i(12, 8),
	Vector2i(12, 10),
	Vector2i(12, 12),
	Vector2i(12, 13),
	Vector2i(12, 15),
	Vector2i(12, 17),
	Vector2i(12, 19),
	Vector2i(13, 6),
	Vector2i(13, 8),
	Vector2i(13, 10),
	Vector2i(13, 12),
	Vector2i(13, 13),
	Vector2i(13, 15),
	Vector2i(13, 17),
	Vector2i(13, 19),
	Vector2i(14, 12),
	Vector2i(14, 13),
	Vector2i(14, 15),
	Vector2i(14, 17),
	Vector2i(14, 19),
	Vector2i(15, 12),
	Vector2i(15, 13),
	Vector2i(15, 15),
	Vector2i(15, 17),
	Vector2i(15, 19),
	Vector2i(16, 12),
	Vector2i(16, 13),
	Vector2i(16, 15),
	Vector2i(16, 17),
	Vector2i(16, 19),
	Vector2i(17, 12),
	Vector2i(17, 13),
	Vector2i(17, 15),
	Vector2i(17, 17),
	Vector2i(17, 19)
]


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
	Sound.sfx(Sound.RECALL)
	Sound.rock_shift = Sound.sfx(Sound.ROCK_SHIFT_REVERSE)
	if not tilemap_count:
		reload()
		return
	active_tilemap.reverse()
	for tilemap in active_tilemap:
		if is_instance_valid(tilemap):
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
