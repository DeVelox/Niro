extends Node2D
@export var first: TileMap


func _ready() -> void:
	# Add a Marker2D called Spawn to change spawn location
	if has_node("Spawn"):
		Data.spawn_point = $Spawn.position
	if not Upgrades.check(Upgrades.Type.VISION):
		get_tree().call_group("hidden", "queue_free")

	_initialise()


func _initialise() -> void:
	Scene.destroy.connect(queue_free, CONNECT_ONE_SHOT)

	var tilemaps := get_tree().get_nodes_in_group("init")
	if not tilemaps:
		modulate = Color(1, 1, 1, 0)
		var tween := create_tween()
		tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 1)
		return
	for i in tilemaps:
		Scene.fade_in_all(i)


func destroy() -> void:
	var tilemaps := get_tree().get_nodes_in_group("free")
	if not tilemaps:
		var tween := create_tween()
		tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1)
		tween.tween_callback(self.queue_free)
		return
	for i in tilemaps:
		Scene.fade_out_all(i)
