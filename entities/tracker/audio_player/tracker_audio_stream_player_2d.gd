class_name TrackerAudioStreamPlayer2D extends AudioStreamPlayer2D

@export var audio_streams_lap_finished: Array[AudioStream] = []
@export var audio_streams_sector_finished: Array[AudioStream] = []
@export var audio_streams_session_finished: Array[AudioStream] = []

func on_lap_finished() -> void:
	play_random_audio_and_await_finished(audio_streams_lap_finished)

func on_sector_finished() -> void:
	play_random_audio_and_await_finished(audio_streams_sector_finished)

func on_session_finished() -> void:
	play_random_audio_and_await_finished(audio_streams_session_finished)

func play_random_audio_and_await_finished(streams: Array[AudioStream] = []) -> void:
	if !streams.is_empty():
		stream = streams.pick_random()
	pitch_scale = randf_range(0.8, 1.2)
	play()
	await finished
