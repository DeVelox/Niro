extends Node

enum Type { SHIELD, VISION, RECALL, SLOWMO }

var active_upgrades: Array[Type] = []
var shield := 1

var buying: Type


func check(upgrade: Type) -> bool:
	return active_upgrades.has(upgrade)


func buy(upgrade: Type) -> void:
	if not active_upgrades.has(upgrade):
		active_upgrades.append(upgrade)


func sell(upgrade: Type) -> void:
	if active_upgrades.has(upgrade):
		active_upgrades.erase(upgrade)


func use_slowmo() -> void:
	var chromatic_aberration := get_node("/root/Main/Shader/ChromaticAberration")
	chromatic_aberration.show()
	Engine.time_scale = 0.5


func end_slowmo() -> void:
	var chromatic_aberration := get_node("/root/Main/Shader/ChromaticAberration")
	chromatic_aberration.hide()
	Engine.time_scale = 1.0


func use_shield() -> bool:
	if shield > 0:
		shield -= 1
		return true
	return false


func add_shield() -> void:
	if shield == 0:
		shield += 1
