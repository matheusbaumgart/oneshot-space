extends Control

@onready var time_label: Label = $VBoxContainer/TimeLabel

func _ready():
	var elapsed_time = GameManager.elapsed_time  # Fetch the recorded time
	time_label.text = "Time: %.2f seconds" % elapsed_time

func _on_button_pressed() -> void:
	reload()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_up"):
		reload()

func reload() -> void:
	AudioManager.resumeAudio()
	get_tree().reload_current_scene()
