extends Node2D

@export var asteroid_scene: PackedScene
@export var area_width: float = 640
@export var start_y: float = -5000
@export var end_y: float = 950
@export var asteroid_count: int = 100
@export var min_spacing: float = 100.0

func _ready():
	generate_asteroids()

func generate_asteroids():
	var positions: Array = []

	var attempts = 0
	while positions.size() < asteroid_count and attempts < asteroid_count * 10:
		var x = randf_range(8, 640)
		var y = randf_range(start_y, end_y)
		var candidate = Vector2(x, y)

		var too_close = false
		for pos in positions:
			if pos.distance_to(candidate) < min_spacing:
				too_close = true
				break

		if not too_close:
			positions.append(candidate)

		attempts += 1

	# Instantiate after calculating all positions
	for pos in positions:
		var asteroid = asteroid_scene.instantiate()
		asteroid.position = pos
		add_child(asteroid)
