extends Node

var start_time = 0.0
var elapsed_time = 0.0

func start_timer():
	start_time = Time.get_ticks_msec() / 1000.0

func stop_timer():
	elapsed_time = (Time.get_ticks_msec() / 1000.0) - start_time
	return elapsed_time
