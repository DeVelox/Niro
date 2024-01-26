extends CanvasLayer

const MENU_ROW = preload("res://prefabs/menu_row.tscn")

@onready var hearts: CheckBox = $MarginContainer/DebugUpgrades/MarginContainer/VBoxContainer/Hearts
@onready var vision: CheckBox = $MarginContainer/DebugUpgrades/MarginContainer/VBoxContainer/Vision
@onready var recall: CheckBox = $MarginContainer/DebugUpgrades/MarginContainer/VBoxContainer/Recall


func _ready() -> void:
	DataStore.debug_properties = _init_properties(owner.get_property_list())
	_init_menu(DataStore.debug_properties, MENU_ROW.instantiate())
	_init_checkbox()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_toggle()


func _init_properties(_properties: Array[Dictionary]) -> Array[String]:
	var list: Array[String] = ["disabled"]
	for property in _properties:
		if property["type"] == 1 and property["usage"] == 4096:
			list.append(property["name"])
	return list


func _init_menu(_properties: Array[String], _menu_row: Node) -> void:
	var add = _menu_row.get_child(0).get_child(3)
	add.pressed.connect(_on_add_pressed)
	%MenuList.add_child(_menu_row)


func _on_add_pressed() -> void:
	_init_menu(DataStore.debug_properties, MENU_ROW.instantiate())


# Debug UI for testing the upgrade system
func _on_hearts_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Upgrades.buy(Upgrades.Type.HEARTS)
		Upgrades.add_heart()
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
	var main = get_node("/root/Main")
	var load_level = load(DataStore.current_scene).instantiate()
	main.add_child(load_level)
	DataStore.current_level.queue_free()
	DataStore.current_level = load_level


func _toggle() -> void:
	if Input.is_action_just_pressed("debug"):
		if visible == true:
			hide()
		else:
			show()
