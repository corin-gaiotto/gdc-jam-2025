extends RestaurantInteractable

var finishedCooking

func interact(player : RestaurantPlayer):
	super.interact(player)
	if storedIngredients.length() == 0:
		$Timer.start()
		storedIngredients.append_array(player.heldIngredients)
	elif finishedCooking:
		var cookedFood = FoodItem.new()
		cookedFood.Ingredients.append_array(storedIngredients)
		
	else:
		$Timer.stop()
		player.heldIngredients.append_array(storedIngredients)
		pass


func _on_timer_timeout() -> void:
	finishedCooking = true
	pass # Replace with function body.
