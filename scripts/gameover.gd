extends Control

func _on_button_pressed() -> void:
	reload()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_up"):
		reload()

func reload() -> void:
	get_tree().reload_current_scene()
