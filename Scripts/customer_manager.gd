extends Node2D

class_name CustomerManager

# Class that handles the spawning of customers.

# [ATTRIBUTES]

@export var CustomerDict         : Dictionary[String, CustomerType] # Dict of available customers to spawn
@export var CustomerWeights      : Dictionary[String, int]          # Dict of integer weights for their spawning rarity

@export var seatArray : Array[Sprite2D]
var seatsFree : Array[bool]

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
var customerTimer = 5.0

func _ready() -> void:
	seatsFree = []
	# populate seatsFree with true for each seat
	for seat in seatArray:
		seatsFree.append(true)
	

func _physics_process(delta: float) -> void:
	if customerTimer < 0:
		var numSeats = 0
		for seat in seatsFree:
			if seat:
				numSeats += 1
		if numSeats > 0:
			spawnRandomCustomer(self)
		customerTimer = randf_range(5, 10)
	customerTimer -= delta

func weightedChoice() -> String:
	# Choose a random customer type name from the weight dict
	var choiceList = []
	for k in CustomerWeights.keys():
		for i in range(CustomerWeights[k]):
			choiceList.append(k)
	var chosenStr = choiceList.pick_random()
	
	return chosenStr

func spawnCustomer(SceneParent : Node, chosenType : CustomerType):
	# Spawns a customer and attaches it as a child of the given parent node
	var customerNode = chosenType.generateCustomer()
	
	# Set customer starting position to the position of the customer door (bottom left, offscreen from the bottom)
	customerNode.global_position = Vector2(100, 1250)
	
	SceneParent.add_child(customerNode)
	
	# Pick an empty seat for the customer
	var seatInd = pickEmptySeatIndex()
	
	# Give customer a target seat position and a seat index (to broadcast back once the seat is free again)
	print(seatArray[seatInd].global_position)
	customerNode.seatPosition = seatArray[seatInd].global_position
	customerNode.seatIndex = seatInd
	
	customerNode.add_user_signal("SeatFree", [{"name":"Index", "type":"int"}])
	customerNode.connect("SeatFree", freeSeat)
	
	# mark seat as occupied
	seatsFree[seatInd] = false


func spawnRandomCustomer(SceneParent : Node):
	# Spawns a random customer and attaches it as a child of the given parent node
	var chosenType = CustomerDict[weightedChoice()]
	
	spawnCustomer(SceneParent, chosenType)

func freeSeat(ind: int):
	seatsFree[ind] = true

func pickEmptySeatIndex():
	# Picks a random empty seat and return its index in the list, assuming there is one (if there isn't, this won't be called)
	var possiblePicks = []
	for i in range(len(seatsFree)):
		if seatsFree[i]:
			possiblePicks.append(i)
	return possiblePicks.pick_random()
