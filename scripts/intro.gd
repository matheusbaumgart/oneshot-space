extends Control
	
@export var main_game_scene: PackedScene  # The game scene after character creation

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_up"):
		loadScene()
		
func _on_button_pressed() -> void:
	loadScene()

func loadScene() -> void:
		get_tree().change_scene_to_packed(main_game_scene)
