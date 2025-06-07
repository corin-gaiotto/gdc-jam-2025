extends Node2D


var tutorialFrames
var mainScene
var fadeIn

@export var showTutorial = true
var TEMPFrameCounter = 0 # temporary for testing
var TEMPFrames = 2 # temporary for testing

func _ready() -> void:
	mainScene = get_parent()
	tutorialFrames = $tutorialFrames
	$TitleScreen.play("default")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("click-menu-interact"):
		#tutorialFrames.Frame += 1
		print("to be added, will show the next frame on tutorialFrames")
		TEMPFrameCounter += 1
		print("frame: ", TEMPFrameCounter, " of ", TEMPFrames)
		if TEMPFrameCounter >= TEMPFrames:
			showTutorial = false
	return
	

func _on_start_button_pressed() -> void:
	if !showTutorial:
		mainScene.switchScene("Fishing")
		print("switching to fishing")
		pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	if !showTutorial:
		get_tree().quit()
