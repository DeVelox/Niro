extends Node

var current_scene: String
var current_level: Node2D
var scene_history: Array[String]

var spawn_point: Vector2

var debug_bools: Array[String]
var debug_values: Array[String]

var stat_to_anim_map: Dictionary


func generate_static_to_animated_map(tilemap: TileMap) -> Dictionary:
	# Get all static tiles
	var static_atlas := _get_atlas_coords_for_all_tiles(tilemap, 1)
	# Get all animated tiles
	var animated_atlas := _get_atlas_coords_for_all_tiles(tilemap, 3)

	var map: Dictionary = {}
	for i in static_atlas:
		map[static_atlas] = [animated_atlas]
	return map


func _get_atlas_coords_for_all_tiles(tilemap: TileMap, layer: int) -> Array[Vector2i]:
	var atlas: Array[Vector2i] = []
	var tiles = tilemap.get_used_cells(1)
	for i in tiles:
		atlas.append(tilemap.get_cell_atlas_coords(layer, i))
	return atlas
