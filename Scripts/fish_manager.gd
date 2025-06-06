extends Node2D

class_name FishManager

# Class that handles the spawning of fish.

# [ATTRIBUTES]

# Dict of available species to spawn, as well as integer weights for their spawning rarity.
@export var SpeciesDict    : Dictionary[String, FishSpecies]
@export var SpeciesWeights : Dictionary[String, int]

# Spawning time is random between these two values
@export var spawnTimeMin : int # in frames (60fps): how long between spawns (minimum)
@export var spawnTimeMax : int # in frames (60fps): how long between spawns (maximum)

# Amount of fish spawned at once is random between these two values
@export var spawnAmountMin : int
@export var spawnAmountMax : int

# [VARIABLES]
# Whether or not to be actively spawning fish.
@export var spawningActive : bool
# How much time before the next spawn.
var spawnTimeRemaining : int = 0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if spawningActive:
		if spawnTimeRemaining < 1:
			spawnTimeRemaining = randi_range(spawnTimeMin, spawnTimeMax)
			
			# spawn fish
			for i in range(randi_range(spawnAmountMin, spawnAmountMax)):
				spawnRandomFish(self) # For now, parent them to the fish manager. This can change in the future if needed.
		
		# Decrement spawn timer
		spawnTimeRemaining -= 1

func weightedChoice() -> String:
	# Choose a random fish species name from the weight dict
	var choiceList = []
	for k in SpeciesWeights.keys():
		for i in range(SpeciesWeights[k]):
			choiceList.append(k)
	var chosenStr = choiceList.pick_random()
	
	return chosenStr

func spawnFish(SceneParent : Node, chosenSpecies : FishSpecies):
	# Spawns a fish and attaches it as a child of the given parent node
	var fishNode = chosenSpecies.generateFish()
	
	# TODO: set position properly. For now, just random between 0 and 400 on each axis
	fishNode.position = Vector2(randf_range(0, 400), randf_range(0, 400))
	
	SceneParent.add_child(fishNode)	


func spawnRandomFish(SceneParent : Node):
	# Spawns a random fish and attaches it as a child of the given parent node
	var chosenSpecies = SpeciesDict[weightedChoice()]
	
	spawnFish(SceneParent, chosenSpecies)
