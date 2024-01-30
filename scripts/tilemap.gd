extends TileMap
@export var set_fade_in: TileMap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if set_fade_in:
		Scene.toggle_layers(set_fade_in, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Scene.should_fade and set_fade_in:
		Scene.should_fade = false
		Scene.can_fade = false
		Scene.fade_in(set_fade_in)
		Scene.fade_out(self)
		Scene.can_fade = true
