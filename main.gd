extends Node
@export_file("*.tscn") var current_scene: String
@onready var spawn: Marker2D = $Spawn
@onready var hearts: CheckBox = $CanvasLayer/Panel/VFlowContainer/Hearts
@onready var vision: CheckBox = $CanvasLayer/Panel/VFlowContainer/Vision
@onready var recall: CheckBox = $CanvasLayer/Panel/VFlowContainer/Recall


# Called when the node enters the scene tree for the first time.
func _ready():
	var load_level: Node2D = load(current_scene).instantiate()
	DataStore.current_level = load_level
	DataStore.current_scene = current_scene
	add_child(load_level)

	var load_player: Node2D = load("res://player/player.tscn").instantiate()
	if DataStore.spawn_point:
		load_player.position = DataStore.spawn_point
	else:
		load_player.position = spawn.position
	add_child(load_player)

	_init_checkbox()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


# Debug UI for testing the upgrade system
func _on_hearts_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Upgrades.buy(Upgrades.Type.HEARTS)
		Upgrades.add_heart()
		print_debug(Upgrades.hearts)
	else:
		Upgrades.sell(Upgrades.Type.HEARTS)
	_reload()


func _on_vision_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Upgrades.buy(Upgrades.Type.VISION)
	else:
		Upgrades.sell(Upgrades.Type.VISION)
	_reload()


func _on_recall_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Upgrades.buy(Upgrades.Type.RECALL)
	else:
		Upgrades.sell(Upgrades.Type.RECALL)
	_reload()


func _init_checkbox():
	hearts.set_pressed_no_signal(Upgrades.check(Upgrades.Type.HEARTS))
	vision.set_pressed_no_signal(Upgrades.check(Upgrades.Type.VISION))
	recall.set_pressed_no_signal(Upgrades.check(Upgrades.Type.RECALL))


func _reload():
	get_tree().reload_current_scene()
