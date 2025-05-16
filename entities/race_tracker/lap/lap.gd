class_name Lap extends Resource

var finished: bool = false:
	set(f):
		if f == finished:
			return
		finished = f
		if f:
			sectors.sector_ended.emit(sectors.current, sectors.all.size())
			sectors.current.finished = true
			sectors.current = null
var sectors: Sectors = Sectors.new()
var time: float = 0.0

func _to_string() -> String:
	var minutes: int = int(time / 60)
	var seconds: int = int(int(time) % 60)
	var milliseconds: int = int((time - int(time)) * 1000)
	
	return "%d:%02d.%03d" % [minutes, seconds, milliseconds]

func set_from_other(other: Lap) -> Lap:
	finished = other.finished
	sectors.set_from_other(other.sectors)
	time = other.time
	return self

func time_tick(delta: float) -> void:
	if finished:
		return
	
	time += delta
	sectors.time_tick(delta)

func to_optimal_lap(other: Lap) -> Lap:
	if other == null:
		return self
	sectors.to_best_sectors(other.sectors)
	time = sectors.get_time()
	return self
