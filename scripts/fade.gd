extends Node2D

const STATIC = preload("res://assets/elliot/TilesetV4.png")
const FADEIN = preload("res://assets/elliot/TilesetV4 Animation.png")
const FADEOUT = preload("res://assets/elliot/TilesetV4_Animation_Reverse.png")

var vision: bool = Upgrades.check(Upgrades.Type.VISION)
var atlas_coords: Vector2i
var atlas_coords_hidden: Vector2i
var tween: Tween

@onready var fade_shader: TextureRect = $FadeShader
@onready var collision: CollisionShape2D = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tilemap := get_parent() as TileMap
	atlas_coords = tilemap.get_cell_atlas_coords(1, tilemap.local_to_map(position))
	atlas_coords_hidden = tilemap.get_cell_atlas_coords(2, tilemap.local_to_map(position))


func fade_in(tilemap: TileMap) -> void:
	if tilemap != get_parent():
		return
	if vision:
		var tile_hidden = tilemap.get_cell_tile_data(2, tilemap.local_to_map(position))
		_fade(tilemap, FADEIN, atlas_coords_hidden, tile_hidden.flip_h, tile_hidden.flip_v)
	var tile = tilemap.get_cell_tile_data(1, tilemap.local_to_map(position))
	_fade(tilemap, FADEIN, atlas_coords, tile.flip_h, tile.flip_v)


func fade_out(tilemap: TileMap) -> void:
	if tilemap != get_parent():
		return
	if vision:
		var tile_hidden = tilemap.get_cell_tile_data(2, tilemap.local_to_map(position))
		_fade(tilemap, FADEOUT, atlas_coords_hidden, tile_hidden.flip_h, tile_hidden.flip_v)
	var tile = tilemap.get_cell_tile_data(1, tilemap.local_to_map(position))
	_fade(tilemap, FADEOUT, atlas_coords, tile.flip_h, tile.flip_v)


func stay(tilemap: TileMap) -> void:
	if tilemap != get_parent():
		return
	if vision:
		var tile_hidden = tilemap.get_cell_tile_data(2, tilemap.local_to_map(position))
		_fade(tilemap, STATIC, atlas_coords_hidden, tile_hidden.flip_h, tile_hidden.flip_v)
	var tile = tilemap.get_cell_tile_data(1, tilemap.local_to_map(position))
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

	if _atlas_texture == STATIC:
		fade_shader.material.set_shader_parameter("frame", 0)
		fade_shader.material.set_shader_parameter("frames", 1)
	else:
		if is_instance_valid(tween):
			tween.kill()
		tween = create_tween()
		if _atlas_texture == FADEOUT:
			tween.tween_property(collision, "disabled", true, 0.5)
		tween.parallel().tween_property(fade_shader.material, "shader_parameter/frame", 9, 1.0)
		tween.tween_property(fade_shader.material, "shader_parameter/toggle", false, 0.0)
		if _atlas_texture == FADEIN:
			tween.tween_callback(Scene.toggle_layers.bind(_tilemap, true))
