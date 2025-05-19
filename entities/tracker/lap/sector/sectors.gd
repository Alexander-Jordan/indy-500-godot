class_name Sectors extends Resource

var current: Sector = null
var first: Sector = null
var second: Sector = null
var third: Sector = null

signal sector_ended(sector: Sector)
signal sector_started(sector: Sector)

func _init(checkpoints: Checkpoints = null) -> void:
	if checkpoints == null:
		return
	
	first = Sector.new(checkpoints.first, checkpoints.second)
	second = Sector.new(checkpoints.second, checkpoints.third)
	third = Sector.new(checkpoints.third, checkpoints.first if checkpoints.loop else checkpoints.forth)
	
	first.finished.connect(on_sector_finish)
	second.finished.connect(on_sector_finish)
	third.finished.connect(on_sector_finish)
	
	start_sector(first)

func _to_string() -> String:
	var s: String = ''
	for sector in [first, second, third]:
		match sector:
			first:
				s += 'S1: %s, ' % sector
			second:
				s += 'S2: %s, ' % sector
			third:
				s += 'S3: %s' % sector
	return s

func on_sector_finish(sector: Sector) -> void:
	current = null
	match sector:
		first:
			sector_ended.emit(sector)
			start_sector(second)
		second:
			sector_ended.emit(sector)
			start_sector(third)
		third:
			sector_ended.emit(sector)

func get_duration() -> float:
	var duration = 0.0
	for sector in [first, second, third]:
		duration += sector.duration
	return duration

func set_from_other(other: Sectors) -> void:
	current = other.current
	first = other.first
	second = other.second
	third = other.third

func start_sector(sector: Sector) -> void:
	match sector:
		first:
			sector.time = 0.0
		second:
			sector.time = first.time
		third:
			sector.time = second.time
	current = sector
	sector_started.emit(sector)

func time_tick(delta: float) -> void:
	if current:
		current.time_tick(delta)

func to_best_sectors(other: Sectors) -> Sectors:
	self.first.to_best_sector(other.first)
	self.second.to_best_sector(other.second)
	self.third.to_best_sector(other.third)
	return self
