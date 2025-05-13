class_name Laps extends Resource

var all: Array[Lap] = []
var current: Lap = null
var max_laps: int = 0

signal finished
signal lap_ended(lap: Lap, number: int)
signal lap_started(number: int)

func end_lap() -> void:
	lap_ended.emit(current, all.size())
	if max_laps == 0 or all.size() < max_laps:
		new_lap()
	else:
		current = null
		finished.emit()

func new_lap() -> void:
	current = Lap.new()
	all.append(current)
	lap_started.emit(all.size())
