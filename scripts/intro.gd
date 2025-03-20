extends Control

@export var main_game_scene: PackedScene  # The game scene after character creation
@export var pulse_speed: float = 2.0  # Time in seconds for a full blink cycle

@onready var start_label: Label = $CanvasLayer/Label

func _ready():
	pulse()

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

func pulse():
	while true:
		var tween = get_tree().create_tween()
		tween.tween_property(start_label, "modulate:a", 0.3, pulse_speed / 2).set_trans(Tween.TRANS_SINE)
		tween.tween_property(start_label, "modulate:a", 1.0, pulse_speed / 2).set_trans(Tween.TRANS_SINE)
		await tween.finished
