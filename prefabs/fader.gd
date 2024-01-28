extends Area2D
@export var set_fade_in: TileMap
@export var set_fade_out: TileMap

var fade_in: TileMap
var fade_out: TileMap

@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	fade_in = set_fade_in if set_fade_in else get_child(1) as TileMap
	fade_out = set_fade_out if set_fade_out else get_parent() as TileMap
	_toggle_layers(fade_in, false)


func _fade_in(tilemap: TileMap) -> void:
	_toggle_layers(tilemap, true)
	get_tree().call_group.call_deferred("fade_in", "fade_in", tilemap)


func _fade_out(tilemap: TileMap) -> void:
	get_tree().call_group("fade_out", "fade_out", tilemap)


func _toggle_layers(tilemap: TileMap, state: bool) -> void:
	for i in tilemap.get_layers_count():
		tilemap.set_layer_enabled(i, state)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		_fade_in(fade_in)
		_fade_out(fade_out)
		collision.set_deferred("disabled", true)
