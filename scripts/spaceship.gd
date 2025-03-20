extends CharacterBody2D

const SPEED = 340  # Speed moving left/right
const MOVE_UP_FORCE = -340  # Upward movement when holding space
const REDUCED_SPEED = 30  # Slower horizontal movement when moving up
var moving_left = true  # Track direction
var is_moving: bool = false  # Track movement state

@onready var engine_fire: AnimatedSprite2D = $"Spaceship body/Engine fire"
@onready var area: Area2D = $Area2D  # Reference to Area2D node
@onready var ui_node = get_tree().current_scene.get_node("UI")  # Reference to UI layer
@onready var audio_explosion: AudioStreamPlayer2D = $AudioExplosion
@onready var audio_win: AudioStreamPlayer2D = $AudioWin
@onready var audio_move_start: AudioStreamPlayer2D = $AudioMoveStart
@onready var audio_move_hold: AudioStreamPlayer2D = $AudioMoveHold
@onready var audio_move_end: AudioStreamPlayer2D = $AudioMoveEnd

@onready var explosion_scene = preload("res://scenes/explosion.tscn")
@onready var game_over_scene = preload("res://scenes/gameover.tscn")
@onready var you_win_scene = preload("res://scenes/win.tscn")

func _ready():
	GameManager.start_timer()  # Start tracking time when the game begins

func _process(delta):
	if Input.is_action_pressed("move_up"):
		if not is_moving:
			is_moving = true
			audio_move_start.play()
			# Don't await; start the hold sound after a short delay instead
			get_tree().create_timer(0.1).timeout.connect(_play_engine_hold)

		engine_fire.play('power')
		velocity.y = MOVE_UP_FORCE
		velocity.x = -REDUCED_SPEED if moving_left else REDUCED_SPEED  # Slower horizontal movement

	else:
		if is_moving:
			audio_move_hold.stop()
			audio_move_end.play()
			is_moving = false

		engine_fire.play('idle')
		velocity.y = 0
		velocity.x = -SPEED if moving_left else SPEED

	move_and_slide()
	check_screen_bounds()

func _play_engine_hold():
	if is_moving and not audio_move_hold.playing:
		audio_move_hold.play()

func check_screen_bounds():
	var screen_width = get_viewport_rect().size.x
	
	if position.x <= 30:
		moving_left = false  # Change direction to right
	elif position.x >= screen_width - 30:
		moving_left = true  # Change direction to left

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("asteroid"):
		explode()
	elif area.is_in_group("finish_line"):
		var time_taken = GameManager.stop_timer()  # Stop timer and get elapsed time
		show_you_win_screen()

func explode():
	audio_explosion.playing = true
	
	# Hide the spaceship instead of removing it
	visible = false
	set_process(false)  # Stop movement processing
	
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_parent().add_child(explosion)

	show_game_over_screen()
	
	# Wait for the explosion animation to finish before game over
	var explosion_anim = explosion.get_node("AnimatedSprite2D")
	await explosion_anim.animation_finished

func show_game_over_screen():
	var game_over_ui = game_over_scene.instantiate()
	ui_node.add_child(game_over_ui)

func show_you_win_screen():
	AudioManager.stopAudio()
	audio_win.playing = true
	set_process(false)  # Stop movement processing
	var you_win_ui = you_win_scene.instantiate()
	ui_node.add_child(you_win_ui)
