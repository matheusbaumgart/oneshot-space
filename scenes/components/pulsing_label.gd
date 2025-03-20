extends Label

var pulse_speed: float = 2.0  # Time in seconds for a full blink cycle

func _ready():
	pulse()

func pulse():
	while true:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate:a", 0.3, pulse_speed / 2).set_trans(Tween.TRANS_SINE)
		tween.tween_property(self, "modulate:a", 1.0, pulse_speed / 2).set_trans(Tween.TRANS_SINE)
		await tween.finished
