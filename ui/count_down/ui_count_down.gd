class_name CountDown extends Control

@export var count_from: int = 3
@export var count_to: int = 0

@onready var audio_stream_player_count_down: AudioStreamPlayer = $audio_stream_player_count_down
@onready var audio_stream_player_go: AudioStreamPlayer = $audio_stream_player_go
@onready var label: Label = $Label
@onready var timer: Timer = $Timer

var count: int = count_from

func _ready() -> void:
	GM.count_down.connect(start)
	GM.reset.connect(reset)
	timer.timeout.connect(on_timeout)

func on_timeout() -> void:
	count -= 1
	if count > count_to:
		label.text = str(count)
		audio_stream_player_count_down.play()
		timer.start()
	elif count == count_to:
		label.text = 'GO!'
		audio_stream_player_go.play()
		timer.start()
	else:
		reset()
		GM.state = GM.State.RACING

func reset() -> void:
	hide()
	timer.stop()
	count = count_from
	label.text = str(count)

func start() -> void:
	show()
	audio_stream_player_count_down.play()
	timer.start()
