extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func stopAudio():
	audio_stream_player.playing = false
	
func resumeAudio():
	audio_stream_player.playing = true
