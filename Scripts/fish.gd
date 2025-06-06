extends AnimatedSprite2D

class_name Fish

# Class for individual fish instances. Has various statistics that are partially randomized, determined by the FishSpecies provided.

#  [ATTRIBUTES]
#    [Catch-related]
@export var size: float                  # Size of the fish, to be displayed when caught.
@export var baseSellValue: float         # Base sell value of the fish.
#    [Visuals]
@export var fishTexture: SpriteFrames    # How the species looks.
#    [Idle Behaviour]
@export var preferredDepth: float        # What depth the fish species appears at.
@export var idleTurnTime: int            # Amount of frames the species spends moving in one direction before turning around (on average)
@export var idleMoveSpeed: float         # How fast the fish moves while idle.
#    [Fishing Behaviour]
@export var fishingTurnTime: int         # Amount of frames the species spends moving in one direction before turning around, while being caught
@export var fishingResistance: float     # Multiplier for how long the fish takes to be reeled in.
@export var fishingEnergyDrain: float    # Multiplier for how much energy the fish drains while reeling it in.

# [DERIVED ATTRIBUTES]
@export var finalSellValue: float        # Sell value of the fish, calculated using its base sell value and its size.

# [VARIABLES]

func _ready() -> void:
	# Called when enters the scene for the first time.
	
	# Set own texture to match fishTexture
	set_sprite_frames(fishTexture)

func _physics_process(delta: float) -> void:
	# Called 60 times per second on a fixed update.
	pass
