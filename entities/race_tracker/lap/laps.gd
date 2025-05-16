class_name Laps extends Resource

var all: Array[Lap] = []
var best: Lap = null
var current: Lap = null
var max_laps: int = 0
var optimal: Lap = null

signal best_changed(best: Lap)
signal finished(laps: Laps)
signal lap_ended(lap: Lap, number: int)
signal lap_started(lap: Lap, number: int)
signal optimal_changed(optimal: Lap)
signal sector_ended(sector: Sector, number: int)
signal sector_started(sector: Sector, number: int)

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
	lap_signals_disconnect(current)
	if max_laps == 0 or all.size() < max_laps:
		new_lap()
	else:
		current = null
		finished.emit(self)

func lap_signals_connect(l: Lap) -> void:
	l.sectors.sector_ended.connect(on_sector_ended)
	l.sectors.sector_started.connect(on_sector_started)

func lap_signals_disconnect(old_lap: Lap) -> void:
	old_lap.sectors.sector_ended.disconnect(on_sector_ended)
	old_lap.sectors.sector_started.disconnect(on_sector_started)

func new_lap() -> void:
	current = Lap.new()
	all.append(current)
	lap_started.emit(current, all.size())
	sector_started.emit(current.sectors.current, current.sectors.all.size())
	lap_signals_connect(current)

func on_sector_ended(sector: Sector, number: int) -> void:
	sector_ended.emit(sector, number)

func on_sector_started(sector: Sector, number: int) -> void:
	sector_started.emit(sector, number)

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
