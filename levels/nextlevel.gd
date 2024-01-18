extends Node2D
var i_dont_feel_so_good = false
var snap_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if snap_time > 0:
		modulate.a = snap_time
		snap_time -= delta
	elif i_dont_feel_so_good:
		queue_free()
	
func destroy(delay = 1.0):
	i_dont_feel_so_good = true
	snap_time = delay
