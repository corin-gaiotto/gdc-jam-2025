extends AnimatedSprite2D

class_name Customer

# [ATTRIBUTES]

@export var customerPatience: float             # Multiplier for time limit on order
@export var customerTip: float                  # Customer tip on top of base price
@export var customerOrder: MenuItem             # List of menu items for customer's order

@export var customerTimer: float                # Total time limit for customer order
@export var totalBill: float                    # Total customer bill with tip

@export var seatPosition: Vector2
@export var seatIndex: int

var targetPosition: Vector2

# [Animations]

@export var orderSatisfied: bool = false
@export var orderExpired: bool = false

@export var isWalking: bool = true
@export var isSitting: bool = false
@export var isHappy: bool = false
@export var isSad: bool = false
var isLeaving: bool = false

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
	
	
	isWalking = true

func _physics_process(delta: float) -> void:
	if targetPosition == Vector2.ZERO:
		targetPosition = seatPosition
	
	
	# When customer sits down
	if (isSitting):
		print("isSitting")
		isWalking = false
		_animatedSprite2D.animation = "sit"
		# Show speech bubble
		_speechBubble.visible = true
		_orderedDish.visible = true
		
		$ServingBox.monitoring = true
		$ServingBox.Order = customerOrder
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
				# leave seat; thus, broadcast signal that seat is free
				leave()
		else:
			_orderedDish.animation = "happy"               # If order satisfied show happy face
			isWalking = true
			# leave seat; thus, broadcast signal that seat is free
			leave()
	
	if (isWalking):
		print("isWalking")
		isSitting = false
		_animatedSprite2D.animation = "walk"
		_animatedSprite2D.play("walk")
		
		# walk towards target position
		var walkResult = walkTowards(targetPosition, 300, delta, isLeaving)
		
		if walkResult == 1:
			if isLeaving:
				# once left the bar, remove self
				queue_free()
			else:
				# sit down to order
				isWalking = false
				isSitting = true
		
	else:
		_animatedSprite2D.stop()
		

func leave():
	emit_signal("SeatFree", seatIndex)
	isLeaving = true
	targetPosition = Vector2(100, 1250) # go back to whence you came
	isWalking = true
	isSitting = false

func walkTowards(target: Vector2, walkSpeed: float, delta: float, horizontal_first: bool = false) -> int:
	print("walking time")
	# walk towards the target position, and return 0 if not arrived and 1 if arrived (+- a few)
	if horizontal_first:
		# prioritize horizontal movement
		if abs(target.x - global_position.x) > walkSpeed * delta:
			# move horizontally
			global_position.x += sign(target.x - global_position.x) * walkSpeed * delta
		elif abs(target.y - position.y) > walkSpeed * delta:
			# move vertically
			global_position.y += sign(target.y - global_position.y) * walkSpeed * delta
		else:
			# arrived
			return 1
	else:
		# prioritize vertical movement
		if abs(target.y - global_position.y) > walkSpeed * delta:
			# move vertically
			global_position.y += sign(target.y - global_position.y) * walkSpeed * delta
		elif abs(target.x - global_position.x) > walkSpeed * delta:
			# move horizontally
			global_position.x += sign(target.x - global_position.x) * walkSpeed * delta
		else:
			# arrived
			return 1
	return 0
