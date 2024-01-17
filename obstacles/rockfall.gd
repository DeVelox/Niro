extends Area2D
@onready var rock = $Rock


# Called when the node enters the scene tree for the first time.
func _ready():
	rock.gravity_scale = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	rock.gravity_scale = 1
