class_name Sectors extends Resource

var all: Array[Sector] = []
var current: Sector = null

signal sector_ended(number: int)
signal sector_started(number: int)

func _init() -> void:
	new_sector()

func _to_string() -> String:
	var s: String = ''
	for index in all.size():
		if index > 0:
			s += ', '
		s += 'S%s: %s' % [index + 1, all[index]]
	return s

func get_time() -> float:
	var time = 0.0
	for sector in all:
		time += sector.time
	return time

func new_sector(checkpoint: Checkpoint = null) -> void:
	if current and checkpoint and current.end_checkpoint_order_id != checkpoint.order_id:
		return
	if current:
		current.finished = true
		sector_ended.emit(current, all.size())
	current = Sector.new()
	if checkpoint:
		current.start_checkpoint_order_id = checkpoint.order_id
	all.append(current)
	sector_started.emit(current, all.size())

func set_from_other(other: Sectors) -> void:
	for index in other.all.size():
		if all.size() <= index:
			all.append(Sector.new().set_from_other(other.all[index]))
		else:
			all[index].set_from_other(other.all[index])
	current = other.current

func time_tick(delta: float) -> void:
	if current:
		current.time_tick(delta)

func to_best_sectors(other: Sectors) -> Sectors:
	for index in other.all.size():
		self.all[index].to_best_sector(other.all[index])
	return self
