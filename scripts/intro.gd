extends Control
	
@export var main_game_scene: PackedScene  # The game scene after character creation

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			Input.action_press("move_up")  # Simulate space key press
		else:
			Input.action_release("move_up")  # Simulate space key release

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_up"):
		loadScene()

func loadScene() -> void:
	get_tree().change_scene_to_packed(main_game_scene)
