extends Node2D

var vision: bool = Upgrades.check(Upgrades.Type.VISION)

func fade_in(tilemap: TileMap) -> void:
	_fade(tilemap, true)

func fade_out(tilemap: TileMap) -> void:
	_fade(tilemap, false)
	
func _fade(tilemap: TileMap, fade: bool) -> void:
	if vision:
		Scene.fade_animation(tilemap, 2, position, fade, 6)
	Scene.fade_animation(tilemap, 1, position, fade, 6)
