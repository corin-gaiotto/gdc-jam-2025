extends Node2D

@export var MoveSpeed = 50

var Direction = Vector2(0,0)

var moving = true

# set any variable fish stats here, could use a resource with preset stats for different types of fish
# fish manually placed in the scene wont work since fish to have initialize called on them to start the timer
func Initialize(MovementCooldown): 
	$Timer.wait_time = MovementCooldown
	$Timer.start()
	
	
	
	Direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	return

func _physics_process(delta: float) -> void:
	#if global_position.x <= 0 or global_position.x >= 2154:
		#HorizontalDirection *= -1
	
	if moving:
		position += 2*Direction
	
	
	return


func _on_timer_timeout() -> void:
	moving = not moving
	if moving:
		Direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	pass # Replace with function body.
