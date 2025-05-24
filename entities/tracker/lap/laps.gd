class_name Laps extends Resource

var all: Array[Lap] = []
var best: Lap = null
var current: Lap = null
var max_laps: int = 0
var optimal: Lap = null
var progress: float = 0.0:
	set(p):
		if p < 0 or p == progress:
			return
		progress = p
		progress_changed.emit(p)

signal best_changed(best: Lap)
signal finished(laps: Laps)
signal lap_ended(lap: Lap, number: int)
signal lap_started(lap: Lap, number: int)
signal optimal_changed(optimal: Lap)
signal progress_changed(progress: float)
signal sector_ended(sector: Sector, number: int)
signal sector_started(sector: Sector, number: int)
signal track_best_changed(track_best: Lap)

func _to_string() -> String:
	var s: String = ''
	for index in all.size():
		s += 'L%s: %s\n' % [index + 1, all[index]]
	if best:
		s += 'Best: %s\n' % best
	if optimal:
		s += 'Optimal: %s\n' % optimal
	return s if s != '' else 'No laps set.'

func lap_signals_connect(l: Lap) -> void:
	l.finished.connect(on_lap_finished)
	l.sector_ended.connect(on_sector_ended)
	l.sector_started.connect(on_sector_started)

func lap_signals_disconnect(l: Lap) -> void:
	l.finished.disconnect(on_lap_finished)
	l.sector_ended.disconnect(on_sector_ended)
	l.sector_started.disconnect(on_sector_started)

func new_lap(checkpoints: Checkpoints) -> void:
	current = Lap.new(checkpoints)
	all.append(current)
	lap_started.emit(current, all.size())
	lap_signals_connect(current)

func on_lap_finished() -> void:
	lap_ended.emit(current, all.size())
	progress += 0.33
	update_best()
	update_optimal()
	update_track_best()
	lap_signals_disconnect(current)
	if max_laps == 0 or all.size() < max_laps:
		new_lap(current.checkpoints)
	else:
		current = null
		finished.emit(self)

func on_sector_ended(sector: Sector, number: int) -> void:
	sector_ended.emit(sector, number)
	progress += 0.33

func on_sector_started(sector: Sector, number: int) -> void:
	sector_started.emit(sector, number)

func reset() -> void:
	all = []
	best = null
	current = null
	optimal = null

func update_best() -> void:
	if best == null or current.time < best.time:
		best = current
		best_changed.emit(best)

func update_optimal() -> void:
	if optimal == null:
		optimal = Lap.new().set_from_other(current)
	else:
		optimal.to_optimal_lap(current)
	
	optimal_changed.emit(optimal)

func update_track_best() -> void:
	if SS.stats.best_lap == null or current.time < SS.stats.best_lap.time:
		SS.stats.best_lap = current
		SS.save_stats()
		track_best_changed.emit(SS.stats.best_lap)
