extends Area2D

class_name RestaurantInteractable

var canInteract = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_entered.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	canInteract = true
	print("interactable range")
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("restaurant-interact"):
		interact()
		print("interacting")
		
func interact():
	print("interactable")
	pass


func _on_body_exited(body: Node2D) -> void:
	canInteract = false
	pass # Replace with function body.
