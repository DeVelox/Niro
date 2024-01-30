extends TileMap
@export var set_fade_in: TileMap
@export var delay: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if set_fade_in:
		Scene.toggle_layers(set_fade_in, false)
		Scene.should_fade.connect(_fade)


func _fade(tilemap: TileMap) -> void:
	if tilemap == self:
		Scene.should_fade.disconnect(_fade)
		Scene.fade_in(set_fade_in)
		Scene.fade_out(self)
