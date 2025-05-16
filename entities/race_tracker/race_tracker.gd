class_name RaceTracker extends Area2D

var checkpoint: Checkpoint = null:
	set(c):
		if c == null:
			checkpoint = c
			return
		
		if checkpoint != null and laps.current == null:
			return
		
		# no previous checkpoint is set
		if checkpoint == null:
			if c.order_id == 0: # only set it if it's the first
				checkpoint = c
				laps.new_lap()
			return # otherwise, just ignore it
		
		# the new checkpoint is the next checkpoint in order
		# OR the new checkpoint is the previous checkpoint in order
		if c.order_id == checkpoint.order_id + 1 or c.order_id == checkpoint.order_id - 1:
			checkpoint = c
			laps.current.sectors.new_sector(c)
			return
	
		# not the next checkpoint by the normal order id, but by the secondary
		# this means that a lap has been completed
		if c.order_id_secondary == checkpoint.order_id + 1:
			checkpoint = c
			laps.end_lap()
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
