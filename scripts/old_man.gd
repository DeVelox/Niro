extends Area2D
@export_multiline var default_lines: Array[String]
@export_multiline var upgrade_lines: Array[String]
@export var upgrade: Upgrades.Type

var seenthisbozobefore: bool = false


# For remotely initiated lines only
func say(lines: Array[String], text_position: Vector2 = global_position) -> void:
	Dialog.end_dialog()
	Dialog.start_dialog(text_position, lines)


func interact() -> void:
	_continue_dialog()

	if Upgrades.check(upgrade):
		_say(["You're so big.", "And powerful."])
	elif seenthisbozobefore:
		_say(["El bozo."])
	else:
		_say(default_lines)

	seenthisbozobefore = true


func _continue_dialog() -> void:
	if Dialog.is_dialog_active:
		if not Dialog.can_advance:
			Dialog.skip_line.emit()
		Dialog.next_line.emit()


func _say(lines: Array[String]) -> void:
	Dialog.start_dialog(global_position, lines)
