extends Area2D
@export_multiline var lines: Array[String]
@export_multiline var buy_text: Array[String]
@export var upgrade: Upgrades.Type


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Data.iveseenthisfuckerbefore and Data.hehasntboughtshit:
		buy()


# Called every frame. 'delta' is the elapsed time since the previous framecd.
func _process(_delta: float) -> void:
	pass


func say(new_lines: Array[String]) -> void:
	Dialog.end_dialog()
	Dialog.start_dialog(global_position, new_lines)


func buy() -> void:
	Dialog.confirmed.connect(_bought, CONNECT_ONE_SHOT)
	Dialog.end_dialog()
	Dialog.start_dialog(global_position, buy_text, true)


func _bought() -> void:
	Upgrades.buy(upgrade)
	Data.hehasntboughtshit = false


func _on_walk_by(_body: Node2D) -> void:
	Data.iveseenthisfuckerbefore = true
	if not Upgrades.check(upgrade):
		Data.hehasntboughtshit = true
		Dialog.start_dialog(global_position, lines)
	else:
		Dialog.start_dialog(global_position, ["You're so big.", "And powerful."])
