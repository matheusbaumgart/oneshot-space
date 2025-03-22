extends Area2D

enum PowerUpType { STAR, SLOW_TIME }

@export var type: PowerUpType = PowerUpType.STAR
@export var value: float = 10.0  # effect duration
@export var drift_speed: float = 10.0
@export var drift_range: float = 20.0
@export var rotation_speed: float = 15.0
@export var max_rotation: float = 15.0  # Maximum rotation angle in degrees

@onready var label: Label = $Label

var direction: int = 1
var start_x: float
var rotation_direction: int = 1

func _ready():
	label.text = str(int(value))
	connect("body_entered", Callable(self, "_on_body_entered"))
	start_x = position.x
	# Randomly set initial rotation direction
	rotation_direction = 1 if randf() > 0.5 else -1

func _process(delta):
	# Oscillating rotation
	rotation_degrees += rotation_speed * rotation_direction * delta
	if abs(rotation_degrees) >= max_rotation:
		rotation_direction *= -1  # Reverse rotation direction
	
	# Side-to-side drifting motion
	position.x += drift_speed * direction * delta

	# Reverse direction when reaching drift limit
	if position.x > start_x + drift_range:
		direction = -1
	elif position.x < start_x - drift_range:
		direction = 1

func _on_body_entered(body):
	if not body.is_in_group("spaceship"):
		return
	
	match type:
		PowerUpType.STAR:
			body.activate_star(value)
		PowerUpType.SLOW_TIME:
			body.activate_slow_time(value)

	queue_free()
