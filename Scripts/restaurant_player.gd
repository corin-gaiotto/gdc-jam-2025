extends CharacterBody2D

class_name RestaurantPlayer

@onready var _animatedSprite = $AnimatedSprite2D


# movement
@export var speed = 200
@export_range(1, 3) var sprintMultiplier: float = 2.25
@export_range(0, 1) var decceleration: float = 0.2
@export var isSprinting: bool = false
@export var canSprint: bool = true

# timers
@export var sprintDuration: float = 2
@export var sprintTimer: float = 0
@export var sprintCD: float = 1.5
@export var CDTimer: float = 0
@export var timeBeforeIdle: float

# appearance
@export var restaurantPlayerSprite: SpriteFrames
@export var lastDir: Vector2
var dir_animation_map : = {
	Vector2.LEFT: "left",
	Vector2.RIGHT: "right",
	Vector2.UP: "up",
	Vector2.DOWN: "down"
}


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
	if (Input.is_action_just_pressed("sprint") and canSprint and _dir != Vector2.ZERO):
		isSprinting = true
		canSprint = false
		sprintTimer = sprintDuration
	
	if isSprinting and not Input.is_action_pressed("sprint"):
		isSprinting = false
		CDTimer = sprintCD
		print("Sprint stopped")
	
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
	
	# update animationsd
	update_anim(_dir)

# chooses the last cardinal direction faced based on absolute values of axes
func get_cardinal(dir: Vector2) -> Vector2:
	if dir == Vector2.ZERO:
		return Vector2.ZERO

	if abs(dir.x) > abs(dir.y):
		return Vector2.RIGHT if dir.x > 0 else Vector2.LEFT
	else: 
		return Vector2.DOWN if dir.y > 0 else Vector2.UP


func update_anim(_dir: Vector2):
	var cardinal_norm = get_cardinal(_dir)
	
	if cardinal_norm != Vector2.ZERO:
		lastDir = cardinal_norm
		_animatedSprite.play(dir_animation_map[cardinal_norm] + "-walk")
		print(dir_animation_map[cardinal_norm] + " walking")
	else:
		if dir_animation_map.has(lastDir):
			_animatedSprite.play(dir_animation_map[lastDir] + "-idle")
			print(dir_animation_map[lastDir] + " idle")
