extends Node

enum Type {RECALL, HEARTS, VISION}

var active_upgrades: Array[Type] = [Type.HEARTS]

func check(upgrade: Type) -> bool:
	return active_upgrades.has(upgrade)
	
func buy(upgrade: Type) -> void:
	if not active_upgrades.has(upgrade):
		active_upgrades.append(upgrade)
