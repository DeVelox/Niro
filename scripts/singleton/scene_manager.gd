extends Node

signal destroy
signal should_fade(tilemap: TileMap)

var current_scene: String
var current_level: Node2D
var scene_history: Array[String]

var spawn_point: Vector2
var fade_in_map: Dictionary = {
	Vector2i(8, 8): Vector2i(0, 0),
	Vector2i(8, 9): Vector2i(0, 1),
	Vector2i(9, 8): Vector2i(1, 0),
	Vector2i(9, 9): Vector2i(1, 1),
	Vector2i(10, 8): Vector2i(2, 0),
	Vector2i(10, 9): Vector2i(2, 1),
	Vector2i(11, 8): Vector2i(3, 0),
	Vector2i(11, 9): Vector2i(3, 1),
	Vector2i(12, 8): Vector2i(4, 0),
	Vector2i(12, 9): Vector2i(4, 1)
}

var fade_out_map: Dictionary = {
	Vector2i(8, 8): Vector2i(0, 1),
	Vector2i(8, 9): Vector2i(0, 2),
	Vector2i(9, 8): Vector2i(1, 1),
	Vector2i(9, 9): Vector2i(1, 2),
	Vector2i(10, 8): Vector2i(2, 1),
	Vector2i(10, 9): Vector2i(2, 2),
	Vector2i(11, 8): Vector2i(3, 1),
	Vector2i(11, 9): Vector2i(3, 2),
	Vector2i(12, 8): Vector2i(4, 1),
	Vector2i(12, 9): Vector2i(4, 2)
}


# Might not be necessary #YOLO
func get_anim(stat: Vector2i, fade: String) -> Vector2i:
	var conv
	if fade == "in":
		conv = fade_in_map.get(stat)
	elif fade == "out":
		conv = fade_out_map.get(stat)
	return conv if conv else stat


func generate_static_to_animated_map(tilemap: TileMap) -> Dictionary:
	# Get all static tiles
	var static_atlas := _get_atlas_coords_for_all_tiles(tilemap, 1)
	# Get all animated tiles
	var animated_atlas := _get_atlas_coords_for_all_tiles(tilemap, 3)

	var map: Dictionary = {}
	for i in static_atlas.size():
		map[static_atlas[i]] = animated_atlas[i]
	return map


func fade_in(tilemap: TileMap) -> void:
	toggle_layers(tilemap, true)
	get_tree().call_group.call_deferred("fade_in", "fade_in", tilemap)


func fade_out(tilemap: TileMap) -> void:
	get_tree().call_group("fade_out", "fade_out", tilemap)
	toggle_layers.call_deferred(tilemap, false)


func toggle_layers(tilemap: TileMap, state: bool) -> void:
	for i in tilemap.get_layers_count():
		tilemap.set_layer_enabled(i, state)


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

# Never operate on all tiles
#func fade_in_all(tilemap: TileMap) -> void:
#toggle_layers(tilemap, true)
#tilemap.set_layer_enabled(1, false)
#var tiles = tilemap.get_used_cells(1)
#var tile: Vector2i
#for i in tiles:
#tile = tilemap.get_cell_atlas_coords(1, i)
#tilemap.set_cell(3, i, 3, get_anim(tile, "in"))
#await get_tree().create_timer(1).timeout
#tilemap.set_layer_enabled(1, true)
#for i in tiles:
#tilemap.erase_cell(3, i)
#
#
#func fade_out_all(tilemap: TileMap) -> void:
#tilemap.set_layer_enabled(1, false)
#var tiles = tilemap.get_used_cells(1)
#var tile: Vector2i
#for i in tiles:
#tile = tilemap.get_cell_atlas_coords(1, i)
#tilemap.set_cell(3, i, 4, get_anim(tile, "out"))
#await get_tree().create_timer(1).timeout
#destroy.emit()
