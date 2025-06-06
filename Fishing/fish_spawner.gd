extends Node2D

@export var scene_list: Array[PackedScene]

func _ready() -> void:
	call_deferred("SpawnFish", 15)

func SpawnFish(numFish):
	for i in range(numFish):
		var instanced_scene = scene_list[0].instantiate()
		instanced_scene.global_position = Vector2(randf_range(450,2100), randf_range(600,1000))
		get_tree().current_scene.add_child(instanced_scene)
		instanced_scene.Initialize(randf_range(3,10), randf_range(100,300))
	return
	
	
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		SpawnFish(10)
