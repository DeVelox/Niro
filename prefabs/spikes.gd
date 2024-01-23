@tool
extends StaticBody2D
@export var sprite: AtlasTexture:
	set(p_sprite):
		if p_sprite != sprite:
			sprite = p_sprite
			if Engine.is_editor_hint():
				_update()

@export_category("Collision shape")
@export var margin: Vector2:
	set(p_margin):
		if p_margin != margin:
			margin = p_margin
			if Engine.is_editor_hint():
				_update()
@export_enum("center", "top", "bottom", "left", "right") var align: String:
	set(p_align):
		if p_align != align:
			align = p_align
			if Engine.is_editor_hint():
				_update()

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var hitbox: CollisionShape2D = $Area2D/CollisionShape2D


func _ready() -> void:
	if sprite or margin or align:
		_update()


func _update() -> void:
	if sprite:
		sprite_2d.texture = sprite

	if sprite_2d:
		hitbox.shape = RectangleShape2D.new()
		collision.shape = RectangleShape2D.new()

		var size := sprite_2d.texture.get_size()
		hitbox.shape.size = size
		if margin < size:
			collision.shape.size = size - margin

		match align:
			"top":
				collision.position.y = -margin.y / 2
			"bottom":
				collision.position.y = margin.y / 2
			"left":
				collision.position.x = -margin.x / 2
			"right":
				collision.position.x = margin.x / 2
			"center":
				collision.position = Vector2(0, 0)


func _on_area_2d_body_entered(body: Node) -> void:
	if body.has_method("try_recall"):
		body.try_recall()
