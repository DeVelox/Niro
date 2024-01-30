class_name TextBox extends MarginContainer

signal finished
signal accepted

const MAX_WIDTH = 256

var index := 0

var time := 0.03

@onready var label: Label = $MarginContainer/Label
@onready var timer: Timer = $Timer


func display_text(text_to_display: String) -> void:
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

	_display_letter()


func _display_letter() -> void:
	label.visible_characters = index
	index += 1
	if index > label.text.length():
		if Dialog.hold:
			await accepted
			Dialog.hold = false
			Dialog.buying = false
			Dialog.confirmed.emit()
		else:
			await get_tree().create_timer(1).timeout
		finished.emit()
		queue_free()
		return
	timer.start(time)


func _on_timer_timeout() -> void:
	_display_letter()
