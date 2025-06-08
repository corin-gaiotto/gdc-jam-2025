extends RestaurantInteractable

var finishedCooking
var base_scale: float

func interact(player : RestaurantPlayer):
	super.interact(player)
	if storedIngredients.size() == 0:
		if player.heldIngredient:
			$Timer.start()
			storedIngredients.append(player.heldIngredient)
			player.heldIngredient = null
			print("[interact] added fish ", storedIngredients[0])
	elif finishedCooking and player.heldIngredient == null:
		storedIngredients[0].Cooked = true
		player.heldIngredient = storedIngredients[0]
		print("[interact] player grabbed cooked food ", player.heldIngredient.Ingredient, player.heldIngredient.baseValue )
		storedIngredients = []
		finishedCooking = false
		
		#cookedFood.Ingredients.append_array(storedIngredients)
	elif player.heldIngredient == null:
		print("[interact] timer wait time ", $Timer.time_left)
		$Timer.stop()
		player.heldIngredient = storedIngredients[0]
		storedIngredients = []
		print("[interact] player grabbed non cooked food from stove ", player.heldIngredient.Ingredient,player.heldIngredient.baseValue)
		pass

func _ready() -> void:
	super._ready()
	base_scale = scale.x

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	self.scale.x = base_scale * (1 + sin($Timer.time_left)*0.2)
	self.scale.y = base_scale * (1 + cos($Timer.time_left)*0.2)

func _on_timer_timeout() -> void:
	finishedCooking = true
	print("[interact] finished Cooking")
	$Timer.stop()
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
