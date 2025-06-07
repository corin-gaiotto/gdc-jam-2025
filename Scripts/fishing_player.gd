extends CharacterBody2D

class_name FishingPlayer

@onready var _animatedSprite = $AnimatedSprite2D
@onready var _hook = $Hook
@onready var _hookSprite = $Hook/HookSprite
@onready var _collisionShape = $CollisionShape2D

@export var _energyBar : TextureProgressBar

var hookedFish: Fish # fish actor that has been hooked

# movement
@export var speed: float = 200
@export var lastWalkedRight: bool = true

# check if in fishing area
@export var canFish: bool = false
@export var isFishing: bool = false
@export var inArea: bool = false


enum fishingEnum {FISHING_IDLE, FISHING_CAST_ANIMATION, FISHING_CAST_IDLE, FISHING_BIT_HOOK, FISHING_PULL_HOOK, FISHING_OBTAIN}
var currentState: int # which of the above enumerated states the player is in (used while isFishing is true)
var stateTimeRemaining: int # amount of time in frames before the state is done. (used for states which transition after some amount of time)

var maxEnergy: float = 240
var energy: float = maxEnergy
var _audioPlayer : AudioStreamPlayer
var _mainScene : Node
signal play_fishing_calm
signal play_fishing_bite

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
	_energyBar.max_value = maxEnergy
	_energyBar.value = energy
	_energyBar.visible = false
	
	_mainScene = get_parent().get_parent()
	if _mainScene:
		# if has parents two layers up, then is running from the main scene.
		# find audio player
		for sibling in _mainScene.get_children():
			if is_instance_of(sibling, AudioStreamPlayer):
				_audioPlayer = sibling
				break
	
	if _audioPlayer:
		print(_audioPlayer)
		play_fishing_calm.connect(_audioPlayer.switch_to_fishing_calm)
		play_fishing_bite.connect(_audioPlayer.switch_to_fishing_bite)
	play_fishing_calm.emit()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# get direction from inputs
	var _x_dir = Input.get_axis("left", "right")
	var _y_dir = Input.get_axis("up", "down")
	var _idle_state = "standing-idle-right";
	
	if _x_dir < 0:
		_idle_state = "standing-idle-left"
		lastWalkedRight = false
	elif _x_dir > 0:
		_idle_state = "standing-idle-right"
		lastWalkedRight = true
	else:
		if lastWalkedRight:
			_idle_state = "standing-idle-right"
		else:
			_idle_state = "standing-idle-left"
	
	# set velocity (only when not fishing)
	if not(isFishing):
		velocity = Vector2(_x_dir * speed * delta, 0)
		if _x_dir < Vector2.ZERO.x:
			_animatedSprite.play("walk-left")
		elif _x_dir > Vector2.ZERO.x:
			_animatedSprite.play("walk-right")
		else:
				_animatedSprite.play(_idle_state)
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
	if canFish and Input.is_action_just_pressed("start-fishing"):
		_animatedSprite.play("fishing-idle")
		isFishing = true
		canFish = false
		currentState = fishingEnum.FISHING_IDLE # Current (maybe) unfortunate side effect: the player casts a line whenever they start fishing. Honestly, this is pretty beneficial so I'm loath to call it a bad side effect.
			
	if isFishing:
		print("[fishing_player]", currentState)
		match currentState:
			
			fishingEnum.FISHING_IDLE:
				_energyBar.visible = false
				if Input.is_action_just_pressed("fishing-interact"):
					# cast a line
					currentState = fishingEnum.FISHING_CAST_ANIMATION
					_animatedSprite.play("fishing-cast-animation")

					stateTimeRemaining = 60 # placeholder
				elif Input.is_action_just_pressed("fishing-cancel"):
					# stop fishing
					isFishing = false
					if inArea:
						canFish = true
			
			fishingEnum.FISHING_CAST_ANIMATION:
				_energyBar.visible = false
				if stateTimeRemaining < 1:
					_animatedSprite.play("fishing-cast-idle")
					currentState = fishingEnum.FISHING_CAST_IDLE
					# make hook visible, and place it correctly
					_hookSprite.visible = true
					_hook.position = Vector2(400, 200) # placeholder: relative to player position
			
			fishingEnum.FISHING_CAST_IDLE:
				_energyBar.visible = false
				# Abilities: move hook in 4 directions, and cancel back to fishing_idle
				
				# TODO: clamp hook global position within the water (once the scene is more set up)
				_hook.position += delta * 50 * Vector2(_x_dir, _y_dir)
				
				if Input.is_action_just_pressed("fishing-cancel"):
					# return to fishing idle
					currentState = fishingEnum.FISHING_IDLE
					_hookSprite.visible = false
			
			fishingEnum.FISHING_BIT_HOOK:
				energy = maxEnergy
				# if stateTimeRemaining runs out, fish gets away; otherwise, if interact pressed, then start reeling in
				if Input.is_action_just_pressed("fishing-interact"):
					currentState = fishingEnum.FISHING_PULL_HOOK
					_hookSprite.visible = false
					# set fish state to reeling (instead of idle)
					print(hookedFish)
					hookedFish.currentState = hookedFish.fishStatesEnum.REELING
				elif stateTimeRemaining < 1:
					# also maybe remove the fish entirely? idk
					currentState = fishingEnum.FISHING_IDLE
					_hookSprite.visible = false
			
			fishingEnum.FISHING_PULL_HOOK:
				_energyBar.visible = true
				_energyBar.value = energy
				play_fishing_bite.emit()
				# here is where the fishing minigame goes: on a success, return to FISHING_OBTAIN, otherwise, return to FISHING_IDLE
				var pull_strength: float = abs(_x_dir) # 0 if not pulling, 1 if pulling
				var energy_cost: float = 1
				pull_strength /= hookedFish.fishingResistance
				energy_cost *= hookedFish.fishingEnergyDrain
				
				if sign(_x_dir) == sign(hookedFish.fishingDirection):
					# pulling in same direction, so increase pull strength and decrease energy cost
					pull_strength *= 3
					energy_cost /= 3
				elif sign(_x_dir) == -1 * sign(hookedFish.fishingDirection):
					# pulling in opposite direction, so decrease pull strength and heavily increase energy cost
					pull_strength /= 2
					energy_cost *= 3
				
				# move the fish upwards based on the pull strength
				hookedFish.position.y -= pull_strength
				
				if pull_strength == 0:
					hookedFish.position.y += hookedFish.fishingResistance
				
				# decrease own energy by energy cost
				energy -= energy_cost
				
				if hookedFish.position.y < 80: # placeholder: wherever water surface will be
					# caught the fish
					print("[minigame] Caught!")
					hookedFish.global_position = global_position + Vector2(0, -80)
					# remove the fish and add its name and price to the list of fish
					_mainScene.conservedData["FishCaught"].append([hookedFish.speciesName, hookedFish.finalSellValue])
					print(_mainScene.conservedData["FishCaught"])
					hookedFish.queue_free()
					currentState = fishingEnum.FISHING_OBTAIN
				elif energy < 0:
					# lost the fish
					print("[minigame] Got away...")
					currentState = fishingEnum.FISHING_IDLE
					hookedFish.currentState = hookedFish.fishStatesEnum.IDLE
					play_fishing_calm.emit()
			
			fishingEnum.FISHING_OBTAIN:
				_energyBar.visible = false
				# wait for the obtain animation to play out, then allow the player to return to FISHING_IDLE using interact
				if stateTimeRemaining < 1 and Input.is_action_just_pressed("fishing-interact"):
					currentState = fishingEnum.FISHING_IDLE
					_hookSprite.visible = false
					play_fishing_calm.emit()
					
		
	stateTimeRemaining -= 1
	





func _on_hook_area_entered(area: Area2D) -> void:
	# Fish collides with hook while hook is active
	if currentState == fishingEnum.FISHING_CAST_IDLE:
		print("[fishing_player] A Bite!")
		hookedFish = area.get_parent()
		currentState = fishingEnum.FISHING_BIT_HOOK
		stateTimeRemaining = 30 # half a second to react to fish bite (placeholder)
		hookedFish.currentState = hookedFish.fishStatesEnum.BITHOOK


func _on_fishing_area_body_entered(body: Node2D) -> void:
	# when entering fishing area
	inArea = true
	canFish = true
	pass # Replace with function body.


func _on_fishing_area_body_exited(body: Node2D) -> void:
	# exiting fishing area
	inArea = false
	canFish = false
	pass # Replace with function body.
