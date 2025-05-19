class_name UIRace extends PanelContainer

@onready var hboxcontainer_position: HBoxContainer = $MarginContainer/VBoxContainer/hboxcontainer_position
@onready var label_lap_number: Label = $MarginContainer/VBoxContainer/HBoxContainer2/label_lap_number
@onready var label_position: Label = $MarginContainer/VBoxContainer/hboxcontainer_position/label_position

var disabled: bool = false:
	set(d):
		if d == disabled:
			return
		disabled = d
		visible = !d
var tracker: Tracker = null:
	set(t):
		if disabled or t == tracker:
			return
		if tracker != null:
			tracker_signals_disconnect(tracker)
		tracker = t
		reset()
		if t != null:
			tracker_signals_connect(t)

func tracker_signals_connect(t: Tracker) -> void:
	t.laps.lap_started.connect(on_lap_started)
	t.finished.connect(on_finished)

func tracker_signals_disconnect(t: Tracker) -> void:
	t.laps.lap_started.disconnect(on_lap_started)
	t.finished.disconnect(on_finished)

func on_lap_started(_lap: Lap, number: int) -> void:
	label_lap_number.text = str(number)

func on_finished(place: int) -> void:
	label_position.text = str(place)
	hboxcontainer_position.show()

func reset() -> void:
	hboxcontainer_position.hide()
	label_lap_number.text = '0'
	label_position.text = '0'
