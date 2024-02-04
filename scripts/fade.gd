extends Node2D

const STATIC = preload("res://assets/elliot/TilesetV5.png")
const FADEIN = preload("res://assets/elliot/TilesetV5 Fade In.png")
const FADEOUT = preload("res://assets/elliot/TilesetV5 Fade Out.png")

var vision: bool = Upgrades.check(Upgrades.Type.VISION)
var atlas_coords: Vector2i
var atlas_coords_hidden: Vector2i
var enable_collision: bool
var is_bottom: bool
var tween: Tween

@onready var fade_shader: TextureRect = $FadeShader
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var rubble: CPUParticles2D = $CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tilemap := get_parent() as TileMap
	var map_pos := tilemap.local_to_map(position)
	atlas_coords = tilemap.get_cell_atlas_coords(1, map_pos)
	atlas_coords_hidden = tilemap.get_cell_atlas_coords(2, map_pos)
	for i in [1, 2]:
		var tile: TileData = tilemap.get_cell_tile_data(i, map_pos)
		if is_instance_valid(tile):
			if tile.get_collision_polygons_count(i) > 0:
				enable_collision = true
	var tile := tilemap.get_cell_atlas_coords(1, Vector2(map_pos.x, map_pos.y + 1))
	if (
		tile == Vector2i(-1, -1)
		and Scene.attachments.has(tilemap.get_cell_atlas_coords(1, map_pos))
	):
		is_bottom = true

	collision.set_disabled.call_deferred("true")


func fade_in(tilemap: TileMap) -> void:
	if tilemap != get_parent():
		return
	if vision:
		var tile_hidden = tilemap.get_cell_tile_data(2, tilemap.local_to_map(position))
		if is_instance_valid(tile_hidden):
			_fade(tilemap, FADEIN, atlas_coords_hidden, tile_hidden.flip_h, tile_hidden.flip_v)
	var tile = tilemap.get_cell_tile_data(1, tilemap.local_to_map(position))
	if is_instance_valid(tile):
		_fade(tilemap, FADEIN, atlas_coords, tile.flip_h, tile.flip_v)


func fade_out(tilemap: TileMap) -> void:
	if tilemap != get_parent():
		return
	if vision:
		var tile_hidden = tilemap.get_cell_tile_data(2, tilemap.local_to_map(position))
		if is_instance_valid(tile_hidden):
			_fade(tilemap, FADEOUT, atlas_coords_hidden, tile_hidden.flip_h, tile_hidden.flip_v)
	var tile = tilemap.get_cell_tile_data(1, tilemap.local_to_map(position))
	if is_instance_valid(tile):
		_fade(tilemap, FADEOUT, atlas_coords, tile.flip_h, tile.flip_v)


func stay(tilemap: TileMap) -> void:
	if tilemap != get_parent():
		return
	if vision:
		var tile_hidden = tilemap.get_cell_tile_data(2, tilemap.local_to_map(position))
		if is_instance_valid(tile_hidden):
			_fade(tilemap, STATIC, atlas_coords_hidden, tile_hidden.flip_h, tile_hidden.flip_v)
	var tile = tilemap.get_cell_tile_data(1, tilemap.local_to_map(position))
	if is_instance_valid(tile):
		_fade(tilemap, STATIC, atlas_coords, tile.flip_h, tile.flip_v)


func _fade(
	_tilemap: TileMap,
	_atlas_texture: CompressedTexture2D,
	_atlas_coords: Vector2i,
	_flip_x: bool = false,
	_flip_y: bool = false
) -> void:
	fade_shader.material.set_shader_parameter("atlas", _atlas_texture)
	fade_shader.material.set_shader_parameter("atlas_x", _atlas_coords.x)
	fade_shader.material.set_shader_parameter("atlas_y", _atlas_coords.y)
	fade_shader.material.set_shader_parameter("flip_x", _flip_x)
	fade_shader.material.set_shader_parameter("flip_y", _flip_y)
	fade_shader.material.set_shader_parameter("frame", 0)
	fade_shader.material.set_shader_parameter("frames", 10)
	fade_shader.material.set_shader_parameter("toggle", true)

	if is_instance_valid(tween):
		tween.kill()
	tween = create_tween()

	if enable_collision and _atlas_texture != FADEIN:
		tween.tween_callback(collision.set_disabled.bind(false))

	if _atlas_texture == STATIC:
		fade_shader.material.set_shader_parameter("frame", 0)
		fade_shader.material.set_shader_parameter("frames", 1)
		tween.tween_callback(collision.set_disabled.bind(true)).set_delay(1.0)
	else:
		if _atlas_texture == FADEOUT:
			tween.tween_callback(collision.set_disabled.bind(true)).set_delay(0.5)
		tween.parallel().tween_property(fade_shader.material, "shader_parameter/frame", 9, 1.0)
		if is_bottom:
			tween.parallel().tween_property(rubble, "emitting", true, 0.0)
			tween.tween_property(rubble, "emitting", false, 0.0)
		if _atlas_texture == FADEIN:
			tween.tween_callback(Scene.toggle_layers.bind(_tilemap, true))
	tween.tween_callback(fade_shader.material.set_shader_parameter.bind("toggle", false))
