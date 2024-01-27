extends MarginContainer

var selected: String

@onready var menu: OptionButton = $MenuItem/Menu
@onready var add: Button = $MenuItem/Add
@onready var remove: Button = $MenuItem/Remove
@onready var label: Label = $MenuItem/Panel/Label
@onready var player: Player = get_parent().owner.owner


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for property in DataStore.debug_values:
		menu.add_item(property)

	selected = "disabled"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var value = player.get(selected)
	if value:
		label.text = str(value)



func _on_menu_item_selected(index: int) -> void:
	selected = menu.get_item_text(index)
	label.text = ""


func _on_add_pressed() -> void:
	add.hide()
	remove.show()


func _on_remove_pressed() -> void:
	queue_free()
