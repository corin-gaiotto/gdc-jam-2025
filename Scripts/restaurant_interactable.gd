extends Area2D

class_name RestaurantInteractable


@export var canInteract = false
@export var storedIngredients = [] #exported for debug
var Player : Node2D

func _ready() -> void:
	print("[interactable] connecting")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	#print("[interact]", canInteract, Input.is_action_just_pressed("restaurant-interact"))
	if canInteract and Input.is_action_just_pressed("restaurant-interact"):
		interact(Player)
		print("[interact]interacting")
		
func interact(player : RestaurantPlayer):
	#print("[interact]interactable")
	pass


func _on_body_entered(body: Node2D) -> void:
	canInteract = true
	Player = get_parent().find_child("RestaurantPlayer")
	print("[interact]interactable range")
	#print(canInteract)
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	print("[interact]exited range")
	canInteract = false
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
