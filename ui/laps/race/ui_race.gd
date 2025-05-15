class_name UIRace extends PanelContainer

@onready var label_lap_number: Label = $MarginContainer/VBoxContainer/HBoxContainer2/label_lap_number

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
		if l != null:
			laps_signals_connect(l)
	get:
		return laps if !disabled else null

func laps_signals_connect(laps: Laps) -> void:
	laps.lap_started.connect(on_lap_started)

func laps_signals_disconnect(laps: Laps) -> void:
	laps.lap_started.disconnect(on_lap_started)

func on_lap_started(lap: Lap, number: int) -> void:
	label_lap_number.text = str(number)
