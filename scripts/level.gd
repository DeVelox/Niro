class_name Level extends Node2D
@export var first: TileMap
@export var last: TileMap
@export var checkpoint: bool = true

@onready var spawn: Marker2D = $Spawn


func _ready() -> void:
	_set_spawn()
	_set_checkpoint()
	_check_vision()
	_music(Data.set_current_track)
	_initialise()


func _set_checkpoint() -> void:
	var existing_checkpoint := get_node_or_null("/root/Main/Checkpoint")
	var place_checkpoint: Checkpoint
	if is_instance_valid(existing_checkpoint):
		place_checkpoint = existing_checkpoint
	else:
		place_checkpoint = load("res://player/checkpoint.tscn").instantiate()
	if checkpoint and Upgrades.check(Upgrades.Type.RECALL):
		place_checkpoint.position = spawn.position
		Data.has_checkpoint = true

		var main := get_node_or_null("/root/Main")
		if is_instance_valid(main):
			if not is_instance_valid(existing_checkpoint):
				main.add_child(place_checkpoint)
		else:
			add_child(place_checkpoint)


func _set_spawn() -> void:
	var player := get_node_or_null("/root/Main/Player")
	var load_player: Player
	if is_instance_valid(player):
		load_player = player
	else:
		load_player = load("res://player/player.tscn").instantiate()

	if Data.set_player_spawn == true:
		load_player.position = Data.set_player_position
	else:
		load_player.position = spawn.position
	Scene.spawn_point = spawn.position

	var main := get_node_or_null("/root/Main")
	if is_instance_valid(main):
		if not is_instance_valid(player):
			main.add_child(load_player)
	else:
		add_child(load_player)


func _check_vision() -> void:
	if not Upgrades.check(Upgrades.Type.VISION):
		for tilemap in get_tree().get_nodes_in_group("hidden") as Array[TileMap]:
			tilemap.set_layer_enabled(2, false)


func _initialise() -> void:
	if first:
		Scene.fade_in(first)


func destroy() -> void:
	if last:
		Scene.fade_out(last)
	queue_free()


func _music(music: String) -> void:
	match music:
		"TRACK1":
			Sound.crossfade(Sound.TRACK_1)
		"TRACK2":
			Sound.crossfade(Sound.TRACK_2)
		"TRACK3":
			Sound.crossfade(Sound.TRACK_3)
		"TRACK4":
			Sound.crossfade(Sound.TRACK_4)
		"TRACK5":
			Sound.crossfade(Sound.TRACK_5)
		"TRACK6":
			Sound.crossfade(Sound.TRACK_6)
		"TRACK7":
			Sound.crossfade(Sound.TRACK_7)
		"TRACK8":
			Sound.crossfade(Sound.TRACK_8)
		"TRACK9":
			Sound.crossfade(Sound.TRACK_9)
		"TRACK10":
			Sound.crossfade(Sound.TRACK_10)
		"TRACK11":
			Sound.crossfade(Sound.TRACK_11)
		"TRACK12":
			Sound.crossfade(Sound.TRACK_12)
