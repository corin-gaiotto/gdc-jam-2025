extends Node

class_name FishSpecies

@onready var fishTemplate = preload("res://Objects/Fish.tscn") # Packed Fish Scene which will be instantiated to create fish.

# Class for a given species of fish. Contains various attributes specific to the species, which are used to generate individual fish.

# NOTE: idea to possibly implement: increase complexity of sell price calculation to include attributes other than size (for instance, a tougher fish to catch should probably sell for more)

#  [ATTRIBUTES]
#    [Catch-related]
@export var size: float                  # Size of the fish, to be displayed when caught. Is randomly varied by some amount in individuals.
@export var baseSellValue: float         # Base sell value of the fish, randomly varied by the eventual size of the individual fish
#    [Visuals]
@export var fishTexture: SpriteFrames    # How the species looks.
#    [Idle Behaviour]
@export var preferredDepth: float        # What depth the fish species appears at.
@export var idleBurstTime: int            # Amount of frames the species spends moving in one direction before turning around (on average)
@export var idleMoveSpeed: float         # How fast the fish moves while idle.
#    [Fishing Behaviour]
@export var fishingTurnTime: int         # Amount of frames the species spends moving in one direction before turning around, while being caught
@export var fishingResistance: float     # Multiplier for how long the fish takes to be reeled in.
@export var fishingEnergyDrain: float    # Multiplier for how much energy the fish drains while reeling it in.

func generateFish() -> Fish:
	# Instantiate an individual randomized fish based on the species attributes, and return it
	var generatedFish : Fish = fishTemplate.instantiate()
	
	# Set attributes based on species
	generatedFish.size = size * randf_range(0.8, 1.2) # TODO: tweak the random ranges later
	generatedFish.baseSellValue = baseSellValue
	
	generatedFish.fishTexture = fishTexture
	
	generatedFish.preferredDepth = preferredDepth * randf_range(0.8, 1.2)
	generatedFish.idleBurstTime = idleBurstTime * randf_range(0.8, 1.2)
	generatedFish.idleMoveSpeed = idleMoveSpeed * randf_range(0.8, 1.2)
	
	generatedFish.fishingTurnTime = fishingTurnTime * randf_range(0.8, 1.2)
	generatedFish.fishingResistance = fishingResistance * randf_range(0.8, 1.2)
	generatedFish.fishingEnergyDrain = fishingEnergyDrain * randf_range(0.8, 1.2)
	
	# Calculate any derived attributes based on the above
	#  Calculate final sell value based on how much it deviates from the typical size
	generatedFish.finalSellValue = generatedFish.baseSellValue * (generatedFish.size)/size
	
	# Visuals: make the generated fish's sprite transform scale with the amount its size is scaling by
	generatedFish.transform = generatedFish.transform.scaled(Vector2((generatedFish.size)/size, (generatedFish.size)/size))
	
	return generatedFish # NOTE: being returned does not automatically add it to the scene tree!
