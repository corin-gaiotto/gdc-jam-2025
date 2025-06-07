extends CharacterBody2D

class_name RestaurantPlayer

# movement
@export var speed = 200
@export_range(1, 3) var sprintMultiplier: float
@export_range(0, 1) var decceleration: float
@export var isSprinting: bool = false
@export var canSprint: bool = true

# timers
@export var sprintDuration: float
@export var sprintTimer: float = 0
@export var sprintCD: float
@export var CDTimer: float = 0
@export var timeBeforeIdle: float

# appearance
@export var restaurantPlayerSprite: SpriteFrames

var heldIngredients = [FoodItem]
var heldMenuItem : MenuItem


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# get movement direction
	var _dir = Input.get_vector("left", "right", "up", "down")
		
	# conditions for player to be able to sprint
	if (Input.is_action_just_pressed("shift") and canSprint and _dir != Vector2.ZERO):
		isSprinting = true
		canSprint = false
		sprintTimer = sprintDuration
	
	# timer updates
	if isSprinting:
		sprintTimer -= delta
		if sprintTimer <= 0:
			isSprinting = false
			CDTimer = sprintCD
			print("Sprint ended")
	elif not canSprint:
		CDTimer -= delta
		if CDTimer <= 0:
			canSprint = true
			print("Can sprint again")
	
	var currSpeed = speed;
	if isSprinting:
		currSpeed *= sprintMultiplier
		
	velocity = _dir.normalized() * currSpeed
	move_and_slide()
	pass
