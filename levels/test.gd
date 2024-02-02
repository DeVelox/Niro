extends Level
@onready var tilemap: TileMap = $Tilemap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_spawn()
	_set_checkpoint()
	_check_vision()
	_initialise()
	await Scene.fade_out(tilemap)
	await Scene.fade_in(tilemap)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
