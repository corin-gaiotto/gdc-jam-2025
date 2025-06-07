extends CharacterBody2D

class_name FishingPlayer

@onready var _animatedSprite = $AnimatedSprite2D

# movement
@export var speed: float = 200

# check if in fishing area
@export var canFish: bool = true
@export var isFishing: bool = false

enum fishingEnum {FISHING_IDLE, FISHING_CAST_ANIMATION, FISHING_CAST_IDLE, FISHING_BIT, FISHING_PULL}

const FISHING_IDLE = "fishing-idle"
const FISHING_CAST_ANIMATION = "fishing-cast-animation"
const FISHING_CAST_IDLE = "fishing-cast-idle"
const FISHING_BIT_HOOK = "fishing-bit-hook"
const FISHING_PULL_HOOK = "fishing-pull-hook"
const FISHING_OBTAIN_FISH = "fishing-obtain-fish"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# get direction from inputs
	var _dir = Input.get_axis("left", "right")
	while _dir != Vector2.ZERO:
		_animatedSprite.play("walking")
		
	# set velocity
	velocity = _dir.normalized()
	move_and_slide()
	
	if canFish and Input.is_action_just_pressed("fishing-interact"):
		_animatedSprite.play(fishingEnum.FISHING_IDLE)
		isFishing = true
		canFish = false
		
	pass
