extends RestaurantInteractable

class_name FishBin

@export var fishType : String



func interact(player : RestaurantPlayer):
	super.interact(player)
	if storedIngredients.size() > 0 and not player.heldIngredient:
		print("[interact] checking fish ", [fishType,storedIngredients[0]])
		var grabbedFish = FoodItem.new() #[fishType,storedIngredients[0]]
		grabbedFish.Ingredient = fishType
		grabbedFish.baseValue = storedIngredients[0]
		storedIngredients.pop_front()
		player.heldIngredient = grabbedFish
		print("[interact] grabbed fish ", player.heldIngredient)
		pass
	
