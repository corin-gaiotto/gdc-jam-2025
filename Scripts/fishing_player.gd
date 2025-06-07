extends CharacterBody2D

class_name FishingPlayer

@onready var _animatedSprite = $AnimatedSprite2D
@onready var _hook = $Hook
@onready var _hookSprite = $Hook/HookSprite

var hookedFish: Fish # fish actor that has been hooked

# movement
@export var speed: float = 200

# check if in fishing area
@export var canFish: bool = true
@export var isFishing: bool = false

enum fishingEnum {FISHING_IDLE, FISHING_CAST_ANIMATION, FISHING_CAST_IDLE, FISHING_BIT_HOOK, FISHING_PULL_HOOK, FISHING_OBTAIN}
var currentState: int # which of the above enumerated states the player is in (used while isFishing is true)
var stateTimeRemaining: int # amount of time in frames before the state is done. (used for states which transition after some amount of time)

# NOTE (Corin): I've commented this out as it's not how enums work. 
# const FISHING_IDLE = "fishing-idle"
# const FISHING_CAST_ANIMATION = "fishing-cast-animation"
# const FISHING_CAST_IDLE = "fishing-cast-idle"
# const FISHING_BIT_HOOK = "fishing-bit-hook"
# const FISHING_PULL_HOOK = "fishing-pull-hook"
# const FISHING_OBTAIN_FISH = "fishing-obtain-fish"

# NOTE: Fishing minigame details
# - Press fishing-interact to cast a line: pressing left, right, up, and down will move the hook slowly in that direction
# - When a fish bites, the player will have some number of frames to start reeling it in before it breaks free.
# - When reeling, press the same horizontal direction that the fish is moving in to reel it in fast at a low energy cost, pressing the opposite direction costs a lot more energy and is slower
# - When the fish is not being actively reeled, it returns downwards to its preferred depth
# - When being reeled in, it is pulled upwards towards the surface
# - When it hits the surface, it is officially caught

func _ready() -> void:
	_hookSprite.visible = false # only display hook's sprite during FISHING_CAST_IDLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# get direction from inputs
	var _x_dir = Input.get_axis("left", "right")
	var _y_dir = Input.get_axis("up", "down")
	
	# set velocity (only when not fishing)
	if not(isFishing):
		velocity = Vector2(_x_dir * speed * delta, 0)
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
	if canFish and Input.is_action_just_pressed("fishing-interact"):
		_animatedSprite.play("fishing-idle")
		isFishing = true
		canFish = false
		currentState = fishingEnum.FISHING_IDLE # Current (maybe) unfortunate side effect: the player casts a line whenever they start fishing. Honestly, this is pretty beneficial so I'm loath to call it a bad side effect.
			
	if isFishing:
		print(currentState)
		match currentState:
			
			fishingEnum.FISHING_IDLE:
				if Input.is_action_just_pressed("fishing-interact"):
					# cast a line
					currentState = fishingEnum.FISHING_CAST_ANIMATION
					_animatedSprite.play("fishing-cast-animation")
					stateTimeRemaining = 60 # placeholder
				elif Input.is_action_just_pressed("fishing-cancel"):
					# stop fishing
					isFishing = false
			
			fishingEnum.FISHING_CAST_ANIMATION:
				if stateTimeRemaining < 1:
					currentState = fishingEnum.FISHING_CAST_IDLE
					# make hook visible, and place it correctly
					_hookSprite.visible = true
					_hook.position = Vector2(400, 200) # placeholder: relative to player position
			
			fishingEnum.FISHING_CAST_IDLE:
				# Abilities: move hook in 4 directions, and cancel back to fishing_idle
				
				# TODO: clamp hook global position within the water (once the scene is more set up)
				_hook.position += delta * 50 * Vector2(_x_dir, _y_dir)
				
				if Input.is_action_just_pressed("fishing-cancel"):
					# return to fishing idle
					currentState = fishingEnum.FISHING_IDLE
					_hookSprite.visible = false
			
			fishingEnum.FISHING_BIT_HOOK:
				# if stateTimeRemaining runs out, fish gets away; otherwise, if interact pressed, then start reeling in
				if Input.is_action_just_pressed("fishing-interact"):
					currentState = fishingEnum.FISHING_PULL_HOOK
					_hookSprite.visible = true
					# set fish state to reeling (instead of idle)
				elif stateTimeRemaining < 1:
					# also maybe remove the fish entirely? idk
					currentState = fishingEnum.FISHING_IDLE
					_hookSprite.visible = false
			
			fishingEnum.FISHING_PULL_HOOK:
				# here is where the fishing minigame goes: on a success, return to FISHING_OBTAIN, otherwise, return to FISHING_IDLE
				pass
			
			fishingEnum.FISHING_OBTAIN:
				# wait for the obtain animation to play out, then allow the player to return to FISHING_IDLE using interact
				if stateTimeRemaining < 1 and Input.is_action_just_pressed("fishing-interact"):
					currentState = fishingEnum.FISHING_IDLE
					_hookSprite.visible = false
					
		
	stateTimeRemaining -= 1


func _on_hook_area_entered(area: Area2D) -> void:
	# Fish collides with hook while hook is active
	if currentState == fishingEnum.FISHING_CAST_IDLE:
		var hookedFish = area.get_parent()
		currentState = fishingEnum.FISHING_BIT_HOOK
