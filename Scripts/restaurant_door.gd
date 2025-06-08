extends RestaurantInteractable

var _mainScene: SceneHandler

func _ready() -> void:
	# find main scene
	if get_parent():
		if get_parent().get_parent():
			if is_instance_of(get_parent().get_parent(), SceneHandler):
				# found it
				_mainScene = get_parent().get_parent()

func interact(player : RestaurantPlayer):
	super.interact(player)
	print("Door back to fishing")
	if _mainScene:
		_mainScene.switchScene("Fishing")
