extends RestaurantInteractable


func interact(player : RestaurantPlayer):
	if storedIngredients.size() == 0 and player.heldIngredient != null:
		storedIngredients.append(player.heldIngredient)
	elif storedIngredients.size() != 0 and player.heldIngredient == null:
		player.heldIngredient = storedIngredients[0]
