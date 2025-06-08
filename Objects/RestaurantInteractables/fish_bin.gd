extends RestaurantInteractable

class_name FishBin

@export var fishType : String



func interact(player : RestaurantPlayer):
	super.interact(player)
	print("[interact] ", storedIngredients.size() > 0, player.heldIngredient)
	if storedIngredients.size() > 0 and player.heldIngredient == null:
		print("[interact] checking fish ", [fishType,storedIngredients[0]])
		var grabbedFish = FoodItem.new() #[fishType,storedIngredients[0]]
		grabbedFish.Ingredient = fishType
		grabbedFish.baseValue = storedIngredients[0]
		storedIngredients.pop_front()
		player.heldIngredient = grabbedFish
		print("[interact] grabbed fish ", player.heldIngredient)
		pass
	elif player.heldIngredient != null and player.heldIngredient.Ingredient == fishType:
		storedIngredients.append([player.heldIngredient.Ingredient, player.heldIngredient.baseValue])
		player.heldIngredient = null
		print("[interact] stored fish in fish bin")
	
