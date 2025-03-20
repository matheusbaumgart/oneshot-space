extends Node2D

#func _input(event):
	#if event is InputEventScreenTouch:
		#if event.pressed:
			#Input.action_press("move_up")  # Simulate space key press
		#else:
			#Input.action_release("move_up")  # Simulate space key release
