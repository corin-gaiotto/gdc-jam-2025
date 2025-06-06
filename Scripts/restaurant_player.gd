extends CharacterBody2D

class_name restaurantPlayer

# movement
@export var speed = 200;
@export_range(1, 3) var sprintMultiplier: float

# timers
@export var sprintDuration: float
@export var sprintCD: float
@export var timeBeforeIdle: float

# appearance
@export var restaurantPlayerSprite: SpriteFrames



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var _dir = Input.get_vector("left", "right", "up", "down")
	velocity = (_dir * speed).normalized()
	
	move_and_slide()
	pass
