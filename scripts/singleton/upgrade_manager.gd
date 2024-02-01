extends Node

enum Type { SHIELD, VISION, RECALL }

var active_upgrades: Array[Type] = [Type.RECALL]
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


func use_shield() -> bool:
	if shield > 0:
		shield -= 1
		return true
	return false


func add_shield() -> void:
	if shield == 0:
		shield += 1
