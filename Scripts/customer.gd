extends AnimatedSprite2D

class_name Customer

# [ATTRIBUTES]

@export var customerPatience: float             # Multiplier for time limit on order
@export var customerTip: float                  # Customer tip on top of base price
@export var customerOrder: MenuItem             # List of menu items for customer's order

@export var customerTimer: float                # Total time limit for customer order
@export var totalBill: float                    # Total customer bill with tip

# [Animations]

@export var orderSatisfied: bool = false
@export var orderExpired: bool = false

@export var isWalking: bool = true
@export var isSitting: bool = false
@export var isHappy: bool = false
@export var isSad: bool = false

@onready var _animatedSprite2D = $AnimatedSprite2D
@onready var _speechBubble = $SpeechBubble
@onready var _orderedDish = $OrderedDish

#[Visuals]
@export var customerTexture: SpriteFrames       #How the customer looks.


func _ready() -> void:
	# Called when enters the scene for the first time.
	
	# Set own texture to match customerTexture
	set_sprite_frames(customerTexture)
	
	_speechBubble.visible = false
	_orderedDish.visible = false

func _physics_process(delta: float) -> void:
	
	# When customer sits down
	

	if (isSitting):
		isWalking = false
		_animatedSprite2D.animation = "sit"
		# Show speech bubble
		_speechBubble.visible = true
		_orderedDish.visible = true
		
		# Customer waiting timer
		customerTimer -= delta
		if customerTimer <= 0:
			orderExpired = true
			print("Order expired")
		
		# Displaying speech bubble content
		if (!orderSatisfied):
			if (!orderExpired):                            # If customer waiting show dish
				_orderedDish.animation = "default"
			else:                                          # If order failed show sad face
				_orderedDish.animation = "sad"
				isWalking = true
		else:
			_orderedDish.animation = "happy"               # If order satisfied show happy face
			isWalking = true
	
	if (isWalking):
		isSitting = false
		_animatedSprite2D.animation = "walk"
		_animatedSprite2D.play("walk")
	else:
		_animatedSprite2D.stop()
		
	pass
