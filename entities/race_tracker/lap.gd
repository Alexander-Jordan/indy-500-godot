class_name Lap extends Resource

var sectors: Array[Sector] = [Sector.new()]
var time: float

func add_sector(start: int = 0, end: int = 1) -> void:
	sectors.append(Sector.new(start, end))

func time_tick(delta: float) -> void:
	time += delta
	sectors[-1].time_tick(delta)
