extends Node2D

var totalTransitionTime: float = 3 # seconds in transition

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	$ColorRect.set_color(Color(0, 0, 0, 0))

func _physics_process(delta: float) -> void:
	if totalTransitionTime < 1:
		$ColorRect.set_color(Color(0, 0, 0, (1 - totalTransitionTime)))
	if totalTransitionTime < 0:
		get_parent().switchScene("Restaurant")
	totalTransitionTime -= delta
