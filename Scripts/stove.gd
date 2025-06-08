extends RestaurantInteractable

var finishedCooking

func interact(player : RestaurantPlayer):
	super.interact(player)
	if storedIngredients.size() == 0:
		if player.heldIngredient:
			$Timer.start()
			storedIngredients.append(player.heldIngredient)
			player.heldIngredient = []
			print("[interact] added fish ", storedIngredients[0])
	elif finishedCooking:
		storedIngredients[0].Cooked = true
		player.heldIngredient = storedIngredients[0]
		print("[interact] player grabbed cooked food ", player.heldIngredient.Ingredient, player.heldIngredient.baseValue )
		storedIngredients = []
		
		#cookedFood.Ingredients.append_array(storedIngredients)
	else:
		print("[interact] timer wait time ", $Timer.time_left)
		$Timer.stop()
		player.heldIngredient = storedIngredients[0]
		storedIngredients = []
		print("[interact] player grabbed non cooked food from stove ", player.heldIngredient.Ingredient,player.heldIngredient.baseValue)
		pass


func _on_timer_timeout() -> void:
	finishedCooking = true
	print("[interact] finished Cooking")
	$Timer.stop()
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
