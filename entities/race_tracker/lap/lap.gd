class_name Lap extends Resource

var checkpoints: Checkpoints = null
var has_finished: bool = false
var sectors: Sectors = null
var time: float = 0.0

signal finished
signal sector_ended(sector: Sector, number: int)
signal sector_started(sector: Sector, number: int)

func _init(c: Checkpoints = null) -> void:
	checkpoints = c
	sectors = Sectors.new(checkpoints)
	sectors.sector_ended.connect(on_sector_ended)
	sectors.sector_started.connect(on_sector_started)

func _to_string() -> String:
	var minutes: int = int(time / 60)
	var seconds: int = int(int(time) % 60)
	var milliseconds: int = int((time - int(time)) * 1000)
	
	return "%d:%02d.%03d" % [minutes, seconds, milliseconds]

func on_sector_ended(sector: Sector) -> void:
	match sector:
		sectors.first:
			sector_ended.emit(sector, 1)
		sectors.second:
			sector_ended.emit(sector, 2)
		sectors.third:
			sector_ended.emit(sector, 3)
			has_finished = true
			finished.emit()

func on_sector_started(sector: Sector) -> void:
	match sector:
		sectors.first:
			sector_started.emit(sector, 1)
		sectors.second:
			sector_started.emit(sector, 2)
		sectors.third:
			sector_started.emit(sector, 3)

func set_from_other(other: Lap) -> Lap:
	sectors.set_from_other(other.sectors)
	time = other.time
	return self

func time_tick(delta: float) -> void:
	if has_finished:
		return
	
	time += delta
	sectors.time_tick(delta)

func to_optimal_lap(other: Lap) -> Lap:
	if other == null:
		return self
	sectors.to_best_sectors(other.sectors)
	time = sectors.get_duration()
	return self
