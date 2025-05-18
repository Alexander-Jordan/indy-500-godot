class_name RaceTracker extends Area2D

var checkpoint: Checkpoint = null:
	set(c):
		if c == null:
			checkpoint = c
			return
		
		# just ignore when there's no current lap in progress
		if checkpoint != null and laps.current == null:
			return
		
		# no previous checkpoint is set
		if checkpoint == null:
			if c == c.checkpoints.get_next(checkpoint): # only if it's the next
				checkpoint = c
				laps.new_lap(c.checkpoints)
			return # otherwise, just ignore it
		
		if c == checkpoint.get_previous():
			checkpoint = c
			return
		
		if c == checkpoint.get_next():
			laps.current.sectors.current.try_end_sector(checkpoint, c)
			checkpoint = c
var laps: Laps = Laps.new():
	set(l):
		laps = l
		laps_changed.emit(l)

signal laps_changed(laps: Laps)

func _process(delta: float) -> void:
	if laps.current:
		laps.current.time_tick(delta)

func _ready() -> void:
	area_entered.connect(func(area: Area2D):
		if area is Checkpoint:
			checkpoint = area
	)
	GM.race_settings.laps_changed.connect(func(number_of_laps: int): laps.max_laps = number_of_laps)

func reset() -> void:
	laps = Laps.new()
	laps.max_laps = GM.race_settings.laps
	checkpoint = null
