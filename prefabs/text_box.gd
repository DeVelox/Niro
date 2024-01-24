class_name TextBox extends MarginContainer

signal finished

const MAX_WIDTH = 256

var text := ""
var index := 0

var time := 0.03

@onready var label: Label = $MarginContainer/Label
@onready var timer: Timer = $Timer


func display_text(text_to_display: String) -> void:
	text = text_to_display
	label.text = text_to_display

	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)

	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y

	global_position.x -= size.x / 2
	global_position.y -= size.y + 24

	label.text = ""
	_display_letter()


func _display_letter() -> void:
	label.text += text[index]
	index += 1

	if index >= text.length():
		finished.emit()
		return
	timer.start(time)


func _on_timer_timeout() -> void:
	_display_letter()
