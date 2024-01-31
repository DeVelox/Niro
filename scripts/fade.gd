extends Node2D

var vision: bool = Upgrades.check(Upgrades.Type.VISION)


func fade_in(tilemap: TileMap, temp_layer: int) -> void:
	if tilemap != get_parent():
		return
	_fade(tilemap, temp_layer, Scene.Source.FADEIN)


func fade_out(tilemap: TileMap, temp_layer: int) -> void:
	if tilemap != get_parent():
		return
	_fade(tilemap, temp_layer, Scene.Source.FADEOUT)


func stay(tilemap: TileMap, temp_layer: int) -> void:
	if tilemap != get_parent():
		return
	_fade(tilemap, temp_layer, Scene.Source.TILE)


func _fade(tilemap: TileMap, temp_layer: int, fade: int) -> void:
	if vision:
		Scene.fade_animation(tilemap, 2, position, fade, temp_layer)
	Scene.fade_animation(tilemap, 1, position, fade, temp_layer)
