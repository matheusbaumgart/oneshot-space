extends Node2D

@onready var spaceship = $Spaceship  # adjust path as needed
@onready var fuel_bar = $UI/ProgressBar  # or FuelLabel

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			Input.action_press("move_up")  # Simulate space key press
		else:
			Input.action_release("move_up")  # Simulate space key release

func _process(delta):
	fuel_bar.value = spaceship.fuel  # for progress bar
