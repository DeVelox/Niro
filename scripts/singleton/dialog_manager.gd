extends Node

signal next_line
signal skip_line

var dialog_lines: Array[String] = []
var current_line := 0

var text_box: TextBox
var text_box_position: Vector2

var is_dialog_active: bool
var can_advance: bool

@onready var text_box_scene = preload("res://prefabs/utility library/text_box.tscn")


func _ready() -> void:
	next_line.connect(_on_next_line)


func start_dialog(position: Vector2, lines: Array[String]) -> void:
	if is_dialog_active:
		return
	if lines.size() > 0:
		dialog_lines = lines
		text_box_position = position
		is_dialog_active = true
		_show_text_box()


func end_dialog() -> void:
	if is_dialog_active:
		current_line = 0
		is_dialog_active = false


func _show_text_box() -> void:
	can_advance = false
	text_box = text_box_scene.instantiate() as TextBox
	text_box.finished.connect(_on_text_box_finished)
	get_tree().root.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line])


func _on_text_box_finished() -> void:
	var size = dialog_lines.size()
	current_line += 1
	if current_line >= size:
		is_dialog_active = false
		current_line = 0
		return
	can_advance = true


func _on_next_line() -> void:
	if is_dialog_active and can_advance:
		_show_text_box()
