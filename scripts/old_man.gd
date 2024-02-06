extends Area2D
@export_multiline var default_lines: Array[String]
@export_multiline var upgrade_lines: Array[String]
@export var upgrade: Upgrades.Type

var seenthisbozobefore: bool = false

@onready var text_show_timer: Timer = $text_show_timer
@onready var text_between_timer: Timer = $text_between_timer


func _ready() -> void:
	Dialog.finished_line.connect(_delay_text_show)


# For remotely initiated lines only
func say(lines: Array[String], text_position: Vector2 = global_position) -> void:
	Dialog.end_dialog()
	Dialog.start_dialog(lines, text_position)
	text_show_timer.stop()
	text_between_timer.stop()


func interact() -> void:
	_continue_dialog()

	#if Upgrades.check(upgrade):
	#_say(["You're so big.", "And powerful."])
	#elif seenthisbozobefore:
	#_say(["El bozo."])
	#else:
	#_say(default_lines)


#
#seenthisbozobefore = true


func _continue_dialog() -> void:
	text_between_timer.stop()
	text_between_timer.stop()
	if Dialog.is_dialog_active:
		if not Dialog.can_advance:
			Dialog.skip_line.emit()
		Dialog.next_line.emit()


func _say(lines: Array[String]) -> void:
	Dialog.start_dialog(lines, global_position)


func _delay_between_words() -> void:
	text_between_timer.start()


func _next_line() -> void:
	if Dialog.is_dialog_active:
		Dialog.next_line.emit()


func _delay_text_show() -> void:
	text_show_timer.start()


func _skip_line() -> void:
	if Dialog.is_dialog_active:
		Dialog.next_line.emit()
		_delay_between_words()
