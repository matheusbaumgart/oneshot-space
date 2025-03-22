extends Area2D

@export var global_rotation_speed: float = 20.0
@export var min_drift_speed: float = 5.0
@export var max_drift_speed: float = 20.0
@export var min_drift_range: float = 10.0
@export var max_drift_range: float = 40.0
@export var min_scale: float = 1.0  
@export var max_scale: float = 1.35 

var drift_speed: float
var drift_range: float
var direction: int = 1
var start_x: float

func _ready():
	start_x = position.x
	drift_speed = randf_range(min_drift_speed, max_drift_speed)
	drift_range = randf_range(min_drift_range, max_drift_range)
	
	# Randomize scale slightly
	var random_scale = randf_range(min_scale, max_scale)
	scale = Vector2(random_scale, random_scale)
	
	_on_ready()  # Hook for child classes

func _process(delta):
	# Rotation
	rotation_degrees += global_rotation_speed * delta

	# Side-to-side drifting motion
	position.x += drift_speed * direction * delta

	# Reverse direction when reaching drift limit
	if position.x > start_x + drift_range:
		direction = -1
	elif position.x < start_x - drift_range:
		direction = 1
		
	_on_process(delta)  # Hook for child classes

# Virtual methods for child classes
func _on_ready():
	pass

func _on_process(_delta):
	pass 