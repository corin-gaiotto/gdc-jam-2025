extends Node2D


func _ready() -> void:
	for bin in get_children():
		if bin is FishBin:
			bin.storedIngredients.append_array(get_parent().conservedData["FishCaught"][bin.fishType])
