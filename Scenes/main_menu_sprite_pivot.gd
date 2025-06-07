extends Node2D

@export var maxRotationDegrees = 8
@export var rotateSpeed = 0.05
var Rotation = 1

func _ready():
	maxRotationDegrees = deg_to_rad(maxRotationDegrees)
	
func _physics_process(delta: float) -> void:
	self.rotate(-delta*Rotation*rotateSpeed)
	if abs(self.rotation) > maxRotationDegrees:
		Rotation *= -1
