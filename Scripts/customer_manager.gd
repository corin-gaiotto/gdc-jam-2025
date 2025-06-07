extends Node2D

class_name CustomerManager

#Class that handles the spawning of customers.

# [ATTRIBUTES]

@export var orderSatisfied: bool

@export var CustomerDict         : Dictionary[String, CustomerType] # Dict of available customers to spawn
@export var CustomerWeights      : Dictionary[String, int]          # Dict of integer weights for their spawning rarity
@export var CustomerMenu         : Dictionary[String, MenuItem]    # Dict of available menu items

# Spawning time is random between these two values
@export var spawnTimeMin : int # in frames (60fps): how long between spawns (minimum)
@export var spawnTimeMax : int # in frames (60fps): how long between spawns (maximum)

# Number of customers spawned at once is random between these two values
@export var spawnAmountMin : int
@export var spawnAmountMax : int

# [VARIABLES]
# Whether or not to be actively spawning customers.
@export var spawningActive : bool
# How much time before the next spawn.
var spawnTimeRemaining : int = 0

func _ready() -> void:
	pass

func weightedChoice() -> String:
	# Choose a random customer type name from the weight dict
	var choiceList = []
	for k in CustomerWeights.keys():
		for i in range(CustomerWeights[k]):
			choiceList.append(k)
	var chosenStr = choiceList.pick_random()
	
	return chosenStr

func spawnCustomer(SceneParent : Node, chosenType : CustomerType, chosenOrder : CustomerOrder):
	# Spawns a customer and attaches it as a child of the given parent node
	var customerNode = chosenType.generateCustomer()
	
	# TODO: set position properly. For now, just random between 0 and 400 on each axis
	customerNode.position = Vector2(randf_range(0, 400), randf_range(0, 400))
	
	SceneParent.add_child(customerNode)	

func customerOrder():
	# Choose a random order combination from menu items
	var choiceList = []
	for k in CustomerMenu.keys():
		for i in range(CustomerMenu[k]):
			choiceList.append(k)
	var orderLengths = [1, 2, 3]
	var chosenOrderLength = orderLengths.pick_random()
	
	var orderList = []
	for k in chosenOrderLength:
		orderList.append(choiceList.pick_random())
			

func spawnRandomCustomer(SceneParent : Node):
	# Spawns a random customer and attaches it as a child of the given parent node
	var chosenType = CustomerDict[weightedChoice()]
	
	spawnCustomer(SceneParent, chosenType, chosenOrder)
