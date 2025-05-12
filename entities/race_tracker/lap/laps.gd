class_name Laps extends Resource

var all: Array[Lap] = [Lap.new()]
var current: Lap = all[-1]
var max: int = 0

signal lap_ended(lap: Lap, number: int)
signal lap_started(number: int)
signal finished

func new_lap() -> void:
	lap_ended.emit(current, all.size())
	if max == 0 or all.size() < max:
		current = Lap.new()
		all.append(current)
		lap_started.emit(all.size())
	else:
		current = null
		finished.emit()
