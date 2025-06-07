extends AnimatedSprite2D

class_name Customer

# [ATTRIBUTES]

@export var customerPatience: float             # Multiplier for time limit on order
@export var customerTip: float                  # Customer tip on top of base price
@export var customerOrder: MenuItem             # List of menu items for customer's order

#[Visuals]
@export var customerTexture: SpriteFrames       #How the customer looks.


func _ready() -> void:
	# Called when enters the scene for the first time.
	
	# Set own texture to match customerTexture
	set_sprite_frames(customerTexture)

func _physics_process(delta: float) -> void:
	# Called 60 times per second on a fixed update.
	pass
