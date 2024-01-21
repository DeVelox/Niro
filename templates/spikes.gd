extends StaticBody2D
@export var sprite : AtlasTexture

@export_category("Collision shape")
@export var margin := Vector2(1,1)
@export_enum ("center", "top", "bottom", "left", "right") var align : String = "center"

@onready var sprite_2d = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var hitbox = $Area2D/CollisionShape2D

func _ready():
	sprite_2d.texture = sprite
	var size = sprite_2d.texture.get_size()
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
	hitbox.shape.size = size

func _on_area_2d_body_entered(body):
	body.try_recall()
