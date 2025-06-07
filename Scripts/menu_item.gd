extends Node

class_name MenuItem

# Class for a given menu item. Contains various attributes specific to the dish.

# [ATTRIBUTES]

@export var ingredients: Array[String]          # Required ingredients
#@export var priceMultiplier: float               # Dish multiplier on top of ingredient value
@export var basePrice: float                    # Base price of dish
@export var baseTimer: float                    #Base time limit of dish

# [Visuals]
@export var menuItemTexture: SpriteFrames       #How the menu item looks.
	
