extends CharacterBody2D

@export var SPEED = 200  # Speed moving left/right
@export var MOVE_UP_FORCE = -380  # Upward movement when holding space
@export var FALL_SPEED = 10  # Downward movement when idle
@export var REDUCED_SPEED = 30  # Slower horizontal movement when moving up

# FUEL
@export var max_fuel: float = 100.0
@export var fuel_depletion_rate: float = 9.5  # units per second while thrusting
@export var idle_fuel_rate: float = 0.8  # units per second for side movement
@export var fuel: float = max_fuel  # starts full

@onready var engine_fire: AnimatedSprite2D = $"Spaceship body/Engine fire"
@onready var area: Area2D = $Area2D  # Reference to Area2D node
@onready var ui_node = get_tree().current_scene.get_node("UI")  # Reference to UI layer
@onready var audio_explosion: AudioStreamPlayer2D = $AudioExplosion
@onready var audio_win: AudioStreamPlayer2D = $AudioWin
@onready var audio_move_start: AudioStreamPlayer2D = $AudioMoveStart
@onready var audio_move_hold: AudioStreamPlayer2D = $AudioMoveHold
@onready var audio_move_end: AudioStreamPlayer2D = $AudioMoveEnd
@onready var collision_polygon_2d: CollisionPolygon2D = $Area2D/CollisionPolygon2D

@onready var explosion_scene = preload("res://scenes/explosion.tscn")
@onready var game_over_scene = preload("res://scenes/gameover.tscn")
@onready var you_win_scene = preload("res://scenes/win.tscn")

var moving_left = true  # Track direction
var is_moving: bool = false  # Track movement state
var is_invincible: bool = false

func _ready():
	GameManager.start_timer()  # Start tracking time when the game begins

func _process(delta):
	if fuel <= 0:
		# No fuel left, trigger game over
		velocity = Vector2.ZERO
		engine_fire.play('idle')
		out_of_fuel()
		return
		
	if Input.is_action_pressed("move_up"):
		if not is_moving:
			is_moving = true
			audio_move_start.play()
			get_tree().create_timer(0.1).timeout.connect(_play_engine_hold)

		# Deplete fuel while thrusting
		fuel = max(0, fuel - fuel_depletion_rate * delta)

		engine_fire.play('power')
		velocity.y = MOVE_UP_FORCE
		velocity.x = -REDUCED_SPEED if moving_left else REDUCED_SPEED
	else:
		if is_moving:
			audio_move_hold.stop()
			audio_move_end.play()
			is_moving = false

		# Deplete smaller amount of fuel for side movement
		fuel = max(0, fuel - idle_fuel_rate * delta)

		engine_fire.play('idle')
		velocity.y = FALL_SPEED  # Add downward movement when not thrusting
		velocity.x = -SPEED if moving_left else SPEED

	move_and_slide()
	check_screen_bounds()

func check_screen_bounds():
	var screen_width = get_viewport_rect().size.x
	
	if position.x <= 30:
		moving_left = false  # Change direction to right
	elif position.x >= screen_width - 30:
		moving_left = true  # Change direction to left

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("asteroid"):
		if not is_invincible:
			explode()
	elif area.is_in_group("finish_line"):
		var time_taken = GameManager.stop_timer()  # Stop timer and get elapsed time
		show_you_win_screen()

func explode():
	audio_explosion.play()
	
	# Disable collision
	collision_polygon_2d.set_deferred("disabled", true)
	
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
	audio_win.play()
	set_process(false)  # Stop movement processing
	var you_win_ui = you_win_scene.instantiate()
	ui_node.add_child(you_win_ui)

func _play_engine_hold():
	if is_moving and not audio_move_hold.playing:
		audio_move_hold.play()

func out_of_fuel():
	set_process(false)  # Stop movement processing
	show_game_over_screen()

func activate_star(duration: float):
	# Activate both shield and speed boost
	is_invincible = true
	
	# Speed boost
	var original_speed = SPEED
	var original_reduced = REDUCED_SPEED
	SPEED *= 1.5
	REDUCED_SPEED *= 1.5
	
	# Visual effect (blinking)
	var blink_timer = duration
	while blink_timer > 0:
		modulate = Color(1, 1, 0)  # yellow/gold for star power
		await get_tree().create_timer(0.1).timeout
		modulate = Color(1, 1, 0, 0.5)  # semi-transparent yellow
		await get_tree().create_timer(0.1).timeout
		blink_timer -= 0.2
	
	# Reset everything
	is_invincible = false
	SPEED = original_speed
	REDUCED_SPEED = original_reduced
	modulate = Color(1, 1, 1, 1)  # reset to default

func activate_slow_time(duration: float):
	Engine.time_scale = 0.5
	await get_tree().create_timer(duration).timeout
	Engine.time_scale = 1.0