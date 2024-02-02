extends Node2D
@onready var fade_in_shader: TextureRect = $FadeInShader


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tilemap := get_parent() as TileMap
	var atlas_coords := tilemap.get_cell_atlas_coords(1, tilemap.local_to_map(position))
	fade_in_shader.material.set_shader_parameter("atlas_x", atlas_coords.x)
	fade_in_shader.material.set_shader_parameter("atlas_y", atlas_coords.y)
	
	var tween := create_tween()
	tween.tween_property(fade_in_shader.material, "shader_parameter/frame", 10, 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
