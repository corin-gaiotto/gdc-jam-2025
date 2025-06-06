extends Area2D

var BurstSpeed = 2
var MovementCooldown = 3

var Direction = Vector2(0,0)
var Velocity = Vector2(0,0)

var moving = true
var MovementTimeLeft

# set any variable fish stats here, could use a resource with preset stats for different types of fish
# fish manually placed in the scene wont work since fish to have initialize called on them to start the timer
func Initialize(Cooldown, Speed): 
	$Timer.wait_time = Cooldown
	$Timer.start()
	
	
	BurstSpeed = Speed
	MovementCooldown = Cooldown
	
	startBurst()
	return
	
func startBurst():
	MovementTimeLeft = MovementCooldown
	Velocity = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()*BurstSpeed
	

func _physics_process(delta: float) -> void:
	#if global_position.x <= 0 or global_position.x >= 2154:
		#HorizontalDirection *= -1
	
	if moving:
		position += Velocity * delta
		Velocity = Velocity.move_toward(Vector2.ZERO, 10 * delta)  # decelerate
		
		if MovementTimeLeft > 0.0:
			var Decay = Velocity / MovementTimeLeft * delta
			Velocity -= Decay
			
			MovementTimeLeft -= delta
	
	return


func _on_timer_timeout() -> void:
	moving = not moving
	if moving:
		startBurst()
	pass # Replace with function body.
