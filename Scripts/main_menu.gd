extends Node2D

var mainScene

func _ready() -> void:
	mainScene = get_parent()

#func playIntro():
	

func _on_start_button_pressed() -> void:
	mainScene.switchScene("Fishing")
	print("switching to fishing")
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	pass # Replace with function body.
