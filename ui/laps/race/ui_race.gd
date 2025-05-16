class_name UIRace extends PanelContainer

@onready var label_lap_number: Label = $MarginContainer/VBoxContainer/HBoxContainer2/label_lap_number
@onready var label_position: Label = $MarginContainer/VBoxContainer/HBoxContainer/label_position

var disabled: bool = false:
	set(d):
		if d == disabled:
			return
		disabled = d
		visible = !d
var laps: Laps = null:
	set(l):
		if disabled or l == laps:
			return
		if laps != null:
			laps_signals_disconnect(laps)
		laps = l
		reset()
		if l != null:
			laps_signals_connect(l)

func laps_signals_connect(new_laps: Laps) -> void:
	new_laps.lap_started.connect(on_lap_started)

func laps_signals_disconnect(old_laps: Laps) -> void:
	old_laps.lap_started.disconnect(on_lap_started)

func on_lap_started(_lap: Lap, number: int) -> void:
	label_lap_number.text = str(number)

func reset() -> void:
	label_lap_number.text = '0'
	label_position.text = '0'
