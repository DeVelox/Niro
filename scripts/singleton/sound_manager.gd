extends Node
# Music
const TRACK_1 = preload("res://assets/music/Track1.ogg")
const TRACK_2 = preload("res://assets/music/Track2.ogg")
const TRACK_3 = preload("res://assets/music/Track3.ogg")
const TRACK_4 = preload("res://assets/music/Track4.ogg")
const TRACK_5 = preload("res://assets/music/Track5.ogg")
const TRACK_6 = preload("res://assets/music/Track6.ogg")
const TRACK_7 = preload("res://assets/music/Track7.ogg")
const TRACK_8 = preload("res://assets/music/Track8.ogg")
const TRACK_9 = preload("res://assets/music/Track9.ogg")
const TRACK_10 = preload("res://assets/music/Track10.ogg")
const TRACK_11 = preload("res://assets/music/Track11.ogg")
const TRACK_12 = preload("res://assets/music/Track12.ogg")

# SFX
const CLIMB_CATCH = preload("res://assets/sfx/climb_catch.ogg")
const CROUCH = preload("res://assets/sfx/crouch.ogg")
const DASH = preload("res://assets/sfx/dash.ogg")
const DOUBLE_JUMP = preload("res://assets/sfx/double_jump.ogg")
const FALLING = preload("res://assets/sfx/falling.ogg")
const JUMP = preload("res://assets/sfx/jump.ogg")
const LANDING = preload("res://assets/sfx/landing.ogg")
const LANDING_STOMP = preload("res://assets/sfx/landing_stomp.ogg")
const RECALL = preload("res://assets/sfx/recall.ogg")
const ROCK_HIT = preload("res://assets/sfx/rock_hit.ogg")
const ROCK_SHIFT = preload("res://assets/sfx/rock_shift.ogg")
const ROCK_SHIFT_REVERSE = preload("res://assets/sfx/rock_shift_reverse.ogg")
const RUNNING = preload("res://assets/sfx/running.ogg")
const SHIELD_CHARGE = preload("res://assets/sfx/shield_charge.ogg")
const SHIELD_HIT = preload("res://assets/sfx/shield_hit.ogg")
const SLIDE = preload("res://assets/sfx/slide.ogg")
const SPIKE_HIT = preload("res://assets/sfx/spike_hit.ogg")
const UPGRADE_GET = preload("res://assets/sfx/upgrade_get.ogg")

# Events
const GIANT = preload("res://assets/sfx/El Gigante.ogg")
const GIANT_DISTANT = preload("res://assets/sfx/Distant El Gigante.ogg")

var current_track: AudioStreamPlayer
var rock_shift: AudioStreamPlayer


func sfx(sound: AudioStream, pitch: float = 1) -> AudioStreamPlayer:
	var audio: AudioStreamPlayer = AudioStreamPlayer.new()
	audio.bus = "Sounds"
	audio.stream = sound
	audio.stream.loop = false
	audio.pitch_scale = pitch
	get_tree().current_scene.add_child(audio)
	audio.finished.connect(audio.queue_free)
	audio.play()
	return audio


func event(sound: AudioStream) -> AudioStreamPlayer:
	var audio: AudioStreamPlayer = AudioStreamPlayer.new()
	audio.bus = "Events"
	audio.stream = sound
	audio.stream.loop = false
	get_tree().current_scene.add_child(audio)
	audio.finished.connect(audio.queue_free)
	audio.play()
	return audio


func music(track: AudioStream, loop: bool = true) -> AudioStreamPlayer:
	if is_instance_valid(current_track) and current_track.stream == track:
		return
	var audio: AudioStreamPlayer = AudioStreamPlayer.new()
	audio.bus = "Music"
	audio.stream = track
	audio.stream.loop = loop
	get_tree().current_scene.add_child(audio)
	audio.finished.connect(audio.queue_free)
	if is_instance_valid(current_track):
		current_track.stop()
	current_track = audio
	audio.play()
	return audio


func crossfade(track: AudioStream, loop: bool = true) -> AudioStreamPlayer:
	if is_instance_valid(current_track) and current_track.stream == track:
		return
	var audio: AudioStreamPlayer = AudioStreamPlayer.new()
	var audio_old = current_track
	audio.bus = "Music"
	audio.stream = track
	audio.stream.loop = loop
	audio.volume_db = -60
	get_tree().current_scene.add_child(audio)
	audio.finished.connect(audio.queue_free)
	current_track = audio
	audio.play()

	var tween := create_tween()
	if is_instance_valid(audio_old):
		tween.tween_property(audio_old, "volume_db", -60, 3)
	tween.parallel().tween_property(audio, "volume_db", 0, 3)
	if is_instance_valid(audio_old):
		tween.tween_callback(audio_old.stop)
	return audio
