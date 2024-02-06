extends Node2D

signal end_cutscene

@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel
@onready var letter_timer: Timer = $LetterTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	end_cutscene.connect(_end_cutscene, CONNECT_ONE_SHOT)
	Sound.music(Sound.TRACK_7)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		end_cutscene.emit()


func _end_cutscene() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_letter_timer_timeout() -> void:
	var clean_text: String = _strip_bbcode(rich_text_label.text)
	var hero_name: String = "NIRO"
	var game_name: String = "POST HUMANITY"
	var hero_name_i: int = clean_text.find(hero_name)
	var game_name_i: int = clean_text.find(game_name)
	rich_text_label.visible_characters += 1
	if rich_text_label.visible_characters == hero_name_i:
		rich_text_label.visible_characters += hero_name.length()
		_pause(1)
	if rich_text_label.visible_characters == game_name_i:
		rich_text_label.visible_characters += game_name.length()
		_pause(2)
	if rich_text_label.visible_characters > clean_text.length():
		_pause(1)
		end_cutscene.emit()


func _strip_bbcode(text: String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	return regex.sub(text, "", true)


func _pause(duration: int) -> void:
	letter_timer.paused = true
	await get_tree().create_timer(duration).timeout
	letter_timer.paused = false
