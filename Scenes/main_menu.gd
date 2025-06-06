extends Node2D



func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Fishing/FishingScene.tscn")
#this will break if fishing scene is moved to a different file location
