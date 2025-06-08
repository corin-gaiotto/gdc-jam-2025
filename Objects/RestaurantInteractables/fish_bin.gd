extends RestaurantInteractable

class_name FishBin

@export var fishType : String



func interact(player : RestaurantPlayer):
	super.interact(player)
	if storedIngredients.length > 0:
		player.heldIngredients.append([fishType,storedIngredients[0]])
		pass
	
