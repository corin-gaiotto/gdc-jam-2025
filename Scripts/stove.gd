extends RestaurantInteractable

var finishedCooking

func interact():
	super.interact()
	if storedIngredients.length() != 0:
		$Timer.start()
	elif finishedCooking:
		#TODO create a new cooked food object and  store fish back in player inventory
		pass
	else:
		$Timer.stop()
		#TODO store fish back in player inventory
		pass

func _process(delta: float) -> void:
	if storedIngredients.length() != 0:
		return


func _on_timer_timeout() -> void:
	finishedCooking = true
	pass # Replace with function body.
