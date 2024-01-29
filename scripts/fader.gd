class_name Fader extends Area2D
@export var set_fade_in: TileMap
@export var set_fade_out: TileMap

var fade_in: TileMap
var fade_out: TileMap

@onready var collision: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	fade_in = set_fade_in if set_fade_in else get_child(1) as TileMap
	fade_out = set_fade_out if set_fade_out else get_parent() as TileMap
	Scene.toggle_layers(fade_in, false)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		Scene.fade_in(fade_in)
		Scene.fade_out(fade_out)
		collision.set_deferred("disabled", true)
