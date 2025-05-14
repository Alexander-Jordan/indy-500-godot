class_name Laps extends Resource

var all: Array[Lap] = []
var best: Lap = null
var current: Lap = null
var max_laps: int = 0
var optimal: Lap = null

signal best_changed(best: Lap)
signal finished(laps: Laps)
signal lap_ended(lap: Lap, number: int)
signal lap_started(number: int)
signal optimal_changed(optimal: Lap)

func _to_string() -> String:
	var s: String = ''
	for index in all.size():
		s += 'L%s: %s\n' % [index + 1, all[index]]
	if best:
		s += 'Best: %s\n' % best
	if optimal:
		s += 'Optimal: %s\n' % optimal
	return s

func end_lap() -> void:
	current.finished = true
	lap_ended.emit(current, all.size())
	update_best()
	update_optimal()
	if max_laps == 0 or all.size() < max_laps:
		new_lap()
	else:
		current = null
		finished.emit(self)

func new_lap() -> void:
	current = Lap.new()
	all.append(current)
	lap_started.emit(all.size())

func reset() -> void:
	all = []
	current = null

func update_best() -> void:
	if best == null or current.time < best.time:
		best = current
		best_changed.emit(best)

func update_optimal() -> void:
	if optimal == null:
		optimal = Lap.new().set_from_other(current)
		optimal_changed.emit(optimal)
		return
	
	optimal.to_optimal_lap(current)
	optimal_changed.emit(optimal)
