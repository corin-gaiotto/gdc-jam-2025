extends Node2D

var currentScene: Node

# Scene Handler: stores data between scenes, and can switch between scenes. This should ideally be done by emitting signals.

@onready var scenes = {
	"MainMenu": preload("res://Scenes/MainMenu.tscn"),
	"Fishing":preload("res://Scenes/Fishing.tscn"),
	"Restaurant":preload("res://Scenes/Restaurant.tscn")
	}

@export var conservedData = {
	"FishCaught": {
		"Anchovy":[10, 20],
		"Horse Mackerel":[]
	}
}

@onready var _musicHandler = $MusicHandler

func _ready() -> void:
	_musicHandler.play()
	currentScene = scenes["MainMenu"].instantiate()
	add_child(currentScene)

func switchScene(sceneName: String):
	currentScene.queue_free()
	currentScene = scenes[sceneName].instantiate()
	add_child(currentScene)
