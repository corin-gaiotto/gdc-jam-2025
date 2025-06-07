extends Node

class_name CustomerType

@onready var customerTemplate = preload("res://Objects/Customer.tscn") # Packed Customer Scene which will be instantiated to create customers.

# Class for a given type of customer. Contains various attributes specific to the type, which are used to generate individual customers.


# [ATTRIBUTES]

@export var customerPatience: float             # Multiplier for time limit on order
@export var customerTip: float                  # Customer tip% (decimal) on top of base price

#[Visuals]
@export var customerTexture: SpriteFrames       #How the customer looks.

func generateCustomer() -> Customer:
	# Instantiate an individual randomized customer based on the type attributes, and return it
	var generatedCustomer : Customer = customerTemplate.instantiate()
	
	# Set attributes based on species
	generatedCustomer.orderTimer = randf_range(0, 30) # TODO: tweak the random ranges later
	generatedCustomer.customerTip = randf_range(0, 1)
	
	# Calculate any derived attributes based on the above
	#  Calculate final payment value based on customer tip
	generatedCustomer.finalSellValue = generatedCustomer.baseOrderValue * (1 + generatedCustomer.customerTip)
	
