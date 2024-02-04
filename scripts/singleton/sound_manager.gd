extends Node
# Music
const TRACK1 = preload("res://assets/music/more options/344252__suchthefool88__psychic-cm.ogg")
const TRACK2 = preload(
	"res://assets/music/more options/488362__soundflakes__dark-dramatic-atmospheric-soundscape.ogg"
)
const TRACK3 = preload(
	"res://assets/music/more options/524309__bertsz__dark-cyberpunk-orchestral-music.ogg"
)
const TRACK4 = preload("res://assets/music/more options/525290__disquantic__cyberpunk-beat.ogg")
const TRACK5 = preload(
	"res://assets/music/more options/611305__szegvari__new-york-cyberpunk-synth-analogue-drums-bass-dance-retro-atmo-ambience-pad-drone-cinematic-action-music-surround.ogg"
)
const TRACK6 = preload("res://assets/music/more options/672783__bertsz__cyberpunk_metal.ogg")

# SFX
const RECALL = preload("res://assets/sfx/recall.ogg")

# Events
const GIANT = preload("res://assets/sfx/El Gigante.ogg")

var current_track: AudioStreamPlayer


func sfx(sound: AudioStream, pitch: float = 1) -> void:
	var audio: AudioStreamPlayer = AudioStreamPlayer.new()
	audio.bus = "Sounds"
	audio.stream = sound
	audio.stream.loop = false
	audio.pitch_scale = pitch
	get_tree().current_scene.add_child(audio)
	audio.finished.connect(audio.queue_free)
	audio.play()


func event(sound: AudioStream) -> void:
	var audio: AudioStreamPlayer = AudioStreamPlayer.new()
	audio.bus = "Events"
	audio.stream = sound
	audio.stream.loop = false
	get_tree().current_scene.add_child(audio)
	audio.finished.connect(audio.queue_free)
	audio.play()


func music(track: AudioStream, loop: bool = true) -> AudioStreamPlayer:
	if current_track and current_track.stream == track:
		return
	var audio: AudioStreamPlayer = AudioStreamPlayer.new()
	audio.bus = "Music"
	audio.stream = track
	audio.stream.loop = loop
	get_tree().current_scene.add_child(audio)
	audio.finished.connect(audio.queue_free)
	if current_track:
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
	tween.tween_property(audio_old, "volume_db", -60, 3)
	tween.parallel().tween_property(audio, "volume_db", 0, 3)
	tween.tween_callback(audio_old.stop)
	return audio
