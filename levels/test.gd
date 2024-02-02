extends Level
@onready var tilemap: TileMap = $Tilemap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_spawn()
	_set_checkpoint()
	_check_vision()
	_initialise()
	
	# Slowmo
	Engine.time_scale = 0.1
	
	# Manual calls of the fade functions (doesn't really work / works weird)
	#await Scene.fade_out(tilemap)
	#await Scene.fade_in(tilemap)
	
	# Manual call of the animation function (works correctly both ways, but starts on a random frame)
	Scene.toggle_layers(tilemap, false)
	tilemap.update_internals()
	for i in tilemap.get_used_cells(1):
		Scene.fade_animation.call_deferred(tilemap, 1, tilemap.map_to_local(i), Scene.Source.FADEOUT, Scene._add_temp_layer(tilemap))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
