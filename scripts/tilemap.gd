extends TileMap
@export var prev: TileMap
@export var next: TileMap
@export var delay: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not prev:
		Scene.active_tilemap.append(self)
	if next:
		Scene.toggle_layers(next, false)
		Scene.should_fade.connect(_fade)


func _fade(tilemap: TileMap) -> void:
	if tilemap == self:
		Scene.should_fade.disconnect(_fade)
		Scene.fade_in(next)
		await Scene.fade_out(self)
		Scene.active_tilemap.append(next)
