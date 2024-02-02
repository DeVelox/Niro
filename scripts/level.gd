class_name Level extends Node2D
@export var first: TileMap
@export var last: TileMap
@export var checkpoint: bool = true

var set_player_spawn: bool


func _ready() -> void:
	_set_spawn()
	_set_checkpoint()
	_check_vision()
	_initialise()


func _set_checkpoint() -> void:
	if get_node_or_null("/root/Main/Checkpoint"):
		return
	if checkpoint and Upgrades.check(Upgrades.Type.RECALL):
		var main := get_node("/root/Main")
		var place_checkpoint: Checkpoint = load("res://player/checkpoint.tscn").instantiate()
		main.add_child(place_checkpoint)


func _set_spawn() -> void:
	if has_node("Spawn"):
		Scene.spawn_point = $Spawn.position

	if set_player_spawn:
		for player in get_tree().get_nodes_in_group("players"):
			player.position = Scene.spawn_point


func _check_vision() -> void:
	if not Upgrades.check(Upgrades.Type.VISION):
		for tilemap in get_tree().get_nodes_in_group("hidden") as Array[TileMap]:
			tilemap.set_layer_enabled(2, false)


func _initialise() -> void:
	if first:
		Scene.fade_in(first)


func destroy() -> void:
	if last:
		await Scene.fade_out(last)
	get_parent().remove_child(self)
	queue_free()
