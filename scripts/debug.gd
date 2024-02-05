extends CanvasLayer

const MENU_BOOL = preload("res://prefabs/utility library/menu_row.tscn")
const MENU_VALUE = preload("res://prefabs/utility library/menu_row_value.tscn")
const DEBUG_PATH = preload("res://prefabs/utility library/debug_path.tscn")

var debug_path: Node2D

@onready var shield: CheckBox = %Shield
@onready var vision: CheckBox = %Vision
@onready var recall: CheckBox = %Recall
@onready var slowmo: CheckBox = %Slowmo
@onready var player: Player = get_parent()


func _ready() -> void:
	Data.debug_bools = _init_properties(owner.get_property_list())
	Data.debug_values = _init_values(owner.get_property_list())
	_init_menu_bools(Data.debug_bools, MENU_BOOL.instantiate())
	_init_menu_values(Data.debug_values, MENU_VALUE.instantiate())
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


func _init_values(_properties: Array[Dictionary]) -> Array[String]:
	var list: Array[String] = ["disabled"]
	var types: Array[int] = [2, 3]
	for property in _properties:
		if property["type"] in types and property["usage"] == 4096:
			list.append(property["name"])
	return list


func _init_menu_bools(_properties: Array[String], _menu_row: Node) -> void:
	var add = _menu_row.get_child(0).get_child(3)
	add.pressed.connect(_on_add_pressed)
	%MenuList.add_child(_menu_row)


func _init_menu_values(_properties: Array[String], _menu_row: Node) -> void:
	var add = _menu_row.get_child(0).get_child(2)
	add.pressed.connect(_on_add_value_pressed)
	%MenuList.add_child(_menu_row)


func _on_add_pressed() -> void:
	_init_menu_bools(Data.debug_bools, MENU_BOOL.instantiate())


func _on_add_value_pressed() -> void:
	_init_menu_values(Data.debug_values, MENU_VALUE.instantiate())


# Debug UI for testing the upgrade system
func _on_shield_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Upgrades.buy(Upgrades.Type.SHIELD)
		Upgrades.add_shield()
	else:
		Upgrades.sell(Upgrades.Type.SHIELD)
	Scene.reload()


func _on_vision_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Upgrades.buy(Upgrades.Type.VISION)
	else:
		Upgrades.sell(Upgrades.Type.VISION)
	Scene.reload()


func _on_recall_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Upgrades.buy(Upgrades.Type.RECALL)
	else:
		Upgrades.sell(Upgrades.Type.RECALL)
	Scene.reload()


func _on_slowmo_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Upgrades.buy(Upgrades.Type.SLOWMO)
	else:
		Upgrades.sell(Upgrades.Type.SLOWMO)
	Scene.reload()


func _init_checkbox() -> void:
	shield.set_pressed_no_signal(Upgrades.check(Upgrades.Type.SHIELD))
	vision.set_pressed_no_signal(Upgrades.check(Upgrades.Type.VISION))
	recall.set_pressed_no_signal(Upgrades.check(Upgrades.Type.RECALL))
	slowmo.set_pressed_no_signal(Upgrades.check(Upgrades.Type.SLOWMO))


func _toggle() -> void:
	if Input.is_action_just_pressed("debug"):
		if visible == true:
			hide()
		else:
			show()


func _on_path_toggle(toggled_on: bool) -> void:
	if toggled_on:
		debug_path = DEBUG_PATH.instantiate()
		player.add_sibling(debug_path)
	else:
		debug_path.queue_free()
