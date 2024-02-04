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
	var audio: AudioStreamPlayer = AudioStreamPlayer.new()
	audio.bus = "Music"
	audio.stream = track
	audio.stream.loop = loop
	get_tree().current_scene.add_child(audio)
	audio.finished.connect(audio.queue_free)
	audio.play()
	return audio


func crossfade(old_track: AudioStreamPlayer, new_track: AudioStream) -> void:
	var audio = music(new_track)
	var tween := create_tween()
	audio.volume_db = -60
	tween.tween_property(old_track, "volume_db", -60, 3)
	tween.parallel().tween_property(audio, "volume_db", 0, 3)
	tween.tween_callback(old_track.stop)
