extends Area2D

var tile_texture: Texture2D

@onready var effect: TextureRect = $Effect
@onready var crumble: Area2D = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crumble.body_entered.connect(_on_body_entered, CONNECT_ONE_SHOT)
	tile_texture = _get_texture()
	effect.material.set_shader_parameter("tile", tile_texture)
	effect.material.set_shader_parameter("alpha", 0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(_body: Node2D) -> void:
	var tilemap := get_parent() as TileMap
	var pos: Vector2 = tilemap.local_to_map(position)
	#tilemap.erase_cell(1, pos)
	var tween := create_tween()
	tween.tween_property(effect.material, "shader_parameter/alpha", 1.0, 0.5)
	for i in tilemap.get_layers_count():
		if i > 0:
			tween.tween_callback(tilemap.erase_cell.bind(i, pos))


func _get_texture() -> Texture2D:
	var tilemap := get_parent() as TileMap
	var pos: Vector2 = tilemap.local_to_map(position)
	var tile: Vector2i = tilemap.get_cell_atlas_coords(1, pos)
	var atlas: TileSetAtlasSource = tilemap.tile_set.get_source(2)
	var region: Rect2i = atlas.get_tile_texture_region(tile)
	var image: Image = atlas.texture.get_image().get_region(region)
	var texture: Texture2D = ImageTexture.create_from_image(image)

	return texture
