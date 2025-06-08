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
		# there is a  rare bug here "Invalid assignment of perpoerty of key 'baseValue' with a type 'Array' on a base object of type'RefCounted (FoodItem)'.
		print("[interact] grabbing fish from fish bin ", grabbedFish.baseValue, grabbedFish, " ", storedIngredients, " ",storedIngredients[0])
		grabbedFish.baseValue = storedIngredients[0]
		storedIngredients.pop_front()
		player.heldIngredient = grabbedFish
		print("[interact] grabbed fish ", player.heldIngredient)
		pass
	elif player.heldIngredient != null and player.heldIngredient.Ingredient == fishType and !player.heldIngredient.Cooked:
		storedIngredients.append(player.heldIngredient.baseValue)
		player.heldIngredient = null
		print("[interact] stored fish in fish bin")
	
