extends Node

enum Type { HEARTS, VISION, RECALL }

var active_upgrades: Array[Type] = []
var hearts := 1


func check(upgrade: Type) -> bool:
	return active_upgrades.has(upgrade)


func buy(upgrade: Type) -> void:
	if not active_upgrades.has(upgrade):
		active_upgrades.append(upgrade)


func sell(upgrade: Type) -> void:
	if active_upgrades.has(upgrade):
		active_upgrades.erase(upgrade)


func use_heart() -> bool:
	if hearts > 0:
		hearts -= 1
		return true
	return false


func add_heart() -> void:
	hearts += 1
