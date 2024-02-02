extends Node2D

const STATIC = preload("res://assets/elliot/TilesetV4.png")
const FADEIN = preload("res://assets/elliot/TilesetV4 Animation.png")
const FADEOUT = preload("res://assets/elliot/TilesetV4_Animation_Reverse.png")

var vision: bool = Upgrades.check(Upgrades.Type.VISION)
var atlas_coords: Vector2i
var atlas_coords_hidden: Vector2i

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
		_fade(tilemap, FADEIN, atlas_coords_hidden)
	_fade(tilemap, FADEIN, atlas_coords)


func fade_out(tilemap: TileMap) -> void:
	if tilemap != get_parent():
		return
	if vision:
		_fade(tilemap, FADEOUT, atlas_coords_hidden)
	_fade(tilemap, FADEOUT, atlas_coords)


func stay(tilemap: TileMap) -> void:
	if tilemap != get_parent():
		return
	if vision:
		_fade(tilemap, STATIC, atlas_coords_hidden)
	_fade(tilemap, STATIC, atlas_coords)


func _fade(_tilemap: TileMap, _atlas_texture: CompressedTexture2D, _atlas_coords: Vector2i) -> void:
	fade_shader.material.set_shader_parameter("frame", 0)
	fade_shader.material.set_shader_parameter("frames", 10)
	fade_shader.material.set_shader_parameter("toggle", true)
	fade_shader.material.set_shader_parameter("atlas", _atlas_texture)
	fade_shader.material.set_shader_parameter("atlas_x", _atlas_coords.x)
	fade_shader.material.set_shader_parameter("atlas_y", _atlas_coords.y)

	if _atlas_texture == STATIC:
		fade_shader.material.set_shader_parameter("frame", 0)
		fade_shader.material.set_shader_parameter("frames", 1)
	else:
		var tween := create_tween()
		if _atlas_texture == FADEOUT:
			tween.tween_property(collision, "disabled", true, 0.5)
		tween.parallel().tween_property(fade_shader.material, "shader_parameter/frame", 9, 1.0)
		tween.tween_property(fade_shader.material, "shader_parameter/toggle", false, 0.0)
		if _atlas_texture == FADEIN:
			tween.tween_callback(Scene.toggle_layers.bind(_tilemap, true))
