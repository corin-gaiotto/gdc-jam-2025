extends AnimatedSprite2D

class_name Fish

# Class for individual fish instances. Has various statistics that are partially randomized, determined by the FishSpecies provided.

#  [ATTRIBUTES]
#    [Catch-related]
@export var size: float                  # Size of the fish, to be displayed when caught.
@export var baseSellValue: float         # Base sell value of the fish.
#    [Visuals]
@export var fishTexture: SpriteFrames    # How the species looks.
#    [Idle Behaviour]
@export var preferredDepth: float        # What depth the fish species appears at.
@export var idleBurstTime: int            # Amount of frames the species spends moving in one direction before turning around (on average)
@export var idleMoveSpeed: float         # How fast the fish moves while idle.
#    [Fishing Behaviour]
@export var fishingTurnTime: int         # Amount of frames the species spends moving in one direction before turning around, while being caught
@export var fishingResistance: float     # Multiplier for how long the fish takes to be reeled in.
@export var fishingEnergyDrain: float    # Multiplier for how much energy the fish drains while reeling it in.

# [DERIVED ATTRIBUTES]
@export var finalSellValue: float        # Sell value of the fish, calculated using its base sell value and its size.

# [VARIABLES]

var idleTimer : Timer
var fishingTimer : Timer

var initialVelocity = Vector2.ZERO
var currentVelocity = Vector2.ZERO
var isBursting = false

enum fishStatesEnum {IDLE, BITHOOK, }
var currentState = 0

var hookLocation = Vector2.ZERO
var fishingDirection = Vector2.ZERO

func _ready() -> void:
	# Called when enters the scene for the first time.
	call_deferred("Initialize")

func Initialize():
	idleTimer = $IdleTimer
	idleTimer.wait_time = idleBurstTime
	
	fishingTimer = $FishingTimer
	fishingTimer.wait_time = fishingTurnTime
	
	idleTimer.start()
	# Set own texture to match fishTexture
	set_sprite_frames(fishTexture)

func _physics_process(delta: float) -> void:
	# Called 60 times per second on a fixed update.
	match currentState:
		fishStatesEnum.IDLE:
			if isBursting:
				currentVelocity = initialVelocity * pow((idleTimer.time_left/idleTimer.wait_time),1.5)
				position += currentVelocity * delta
		fishStatesEnum.BITHOOK:
			position.y -= delta
			position += fishingDirection*(1 - ((global_position - hookLocation).length()/10))
			
			
	
#	var depthDeviation = position.y - preferredDepth
#	if depthDeviation > 20:
#		Velocity.y -= maxf(depthDeviation/idleMoveSpeed ,1)
#	elif depthDeviation < 20:
#		Velocity.y += maxf(depthDeviation/idleMoveSpeed ,1)
	
	
	pass

func applyIdleBurst():
	print(self.name)
	initialVelocity = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized() * idleMoveSpeed
	print(initialVelocity)
	var depthDeviation = position.y - preferredDepth
	if depthDeviation > 20:
		initialVelocity.y -= maxf(depthDeviation/idleMoveSpeed ,1)
	elif depthDeviation < 20:
		initialVelocity.y += maxf(depthDeviation/idleMoveSpeed ,1)
	

func _on_idle_timer_timeout() -> void:
	initialVelocity = Vector2.ZERO
	if !isBursting:
		applyIdleBurst()

		
		
	isBursting = !isBursting
	idleTimer.start()
	pass # Replace with function body.


func _on_fishing_timer_timeout() -> void:
	var Direction = Vector2(randf_range(-1,1),randf_range(0,1)).normalized()
		
	pass # Replace with function body.
