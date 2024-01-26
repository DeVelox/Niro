extends MarginContainer

var selected: String
var inverted: bool
var tint: Color

@onready var menu: OptionButton = $MenuItem/Menu
@onready var invert: Button = $MenuItem/Invert
@onready var picker: ColorPickerButton = $MenuItem/Color
@onready var add: Button = $MenuItem/Add
@onready var remove: Button = $MenuItem/Remove
@onready var player: Player = get_parent().owner.owner


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for property in DataStore.debug_properties:
		menu.add_item(property)
	picker.color = Color.from_hsv(randf(), 1, 1)

	selected = "disabled"
	inverted = false
	tint = picker.color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	player.debug_color(selected, inverted, tint)
	_highlight()


func _highlight() -> void:
	var color: Color = Color.GREEN
	var state = player.get(selected)
	if inverted:
		color = Color.RED
		state = not state
	if state:
		menu.set("theme_override_colors/font_color", color)
	else:
		menu.set("theme_override_colors/font_color", Color.WHITE)


func _on_menu_item_selected(index: int) -> void:
	selected = menu.get_item_text(index)


func _on_invert_toggled(toggled_on: bool) -> void:
	inverted = toggled_on


func _on_color_color_changed(color: Color) -> void:
	tint = color


func _on_add_pressed() -> void:
	add.hide()
	remove.show()


func _on_remove_pressed() -> void:
	queue_free()
