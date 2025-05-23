class_name CountDown extends Control

@export var count_from: int = 3
@export var count_to: int = 0

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
		timer.start()
	elif count == count_to:
		label.text = 'GO!'
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
	timer.start()
