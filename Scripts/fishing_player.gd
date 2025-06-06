extends CharacterBody2D

class_name FishingPlayer

# movement
@export var speed: float = 200

# check if in fishing area
@export var canFish: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# get direction from inputs
	var _dir = Input.get_axis("left", "right")
	
	# set velocity
	velocity = _dir.normalized()
	move_and_slide()
	pass
