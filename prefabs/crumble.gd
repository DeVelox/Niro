extends Area2D
@onready var crack: TextureRect = $TextureRect
@onready var crumble: Area2D = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crumble.body_entered.connect(_on_body_entered, CONNECT_ONE_SHOT)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(_body: Node2D) -> void:
	var tilemap := get_parent() as TileMap
	var pos: Vector2 = tilemap.local_to_map(position)
	var tween := create_tween()
	tween.tween_property(crack, "modulate", Color(1, 1, 1, 1), 0.5)
	tween.tween_callback(tilemap.erase_cell.bind(1, pos))
	tween.tween_callback(tilemap.erase_cell.bind(2, pos))
