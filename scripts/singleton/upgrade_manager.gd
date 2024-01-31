extends Node

enum Type { SHIELDS, VISION, RECALL }

var active_upgrades: Array[Type] = [Type.RECALL]
var shields := 1

var buying: Type


func check(upgrade: Type) -> bool:
	return active_upgrades.has(upgrade)


func buy(upgrade: Type) -> void:
	if not active_upgrades.has(upgrade):
		active_upgrades.append(upgrade)


func sell(upgrade: Type) -> void:
	if active_upgrades.has(upgrade):
		active_upgrades.erase(upgrade)


func use_shield() -> bool:
	if shields > 0:
		shields -= 1
		return true
	return false


func add_shield() -> void:
	if shields == 0:
		shields += 1
