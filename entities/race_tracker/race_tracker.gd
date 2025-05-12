class_name RaceTracker extends Area2D

@export var laps_max: int = 0

var checkpoint: Checkpoint = null:
	set(c):
		if lap_current == null:
			return
		
		var last: Checkpoint = checkpoint
		
		# no previous checkpoint is set
		if last == null:
			if c.order_id == 0: # only set it if it's the first
				checkpoint = c
				checkpoint_changed.emit(c)
			return # otherwise, just ignore it
		
		# the new checkpoint is the next checkpoint in order
		# OR the new checkpoint is the previous checkpoint in order
		if c.order_id == last.order_id + 1 or c.order_id == last.order_id - 1:
			checkpoint = c
			checkpoint_changed.emit(c)
			if c.order_id == lap_current.sectors[-1].end_checkpoint_order_id:
				lap_current.add_sector(c.order_id, c.order_id + 1)
			return
	
		# not the next checkpoint by the normal order id, but by the secondary
		# this means that a lap has been completed
		if c.order_id_secondary == last.order_id + 1:
			checkpoint = c
			checkpoint_changed.emit(c)
			lap_ended.emit(lap_current, laps.size())
			if laps_max == 0 or laps.size() < laps_max:
				laps.append(Lap.new())
				lap_current = laps[-1]
				lap_started.emit(laps.size())
			else:
				lap_current = null
				race_over.emit()
var laps: Array[Lap] = [Lap.new()]
var lap_current: Lap = laps[-1]

signal checkpoint_changed(checkpoint: Checkpoint)
signal lap_ended(lap: Lap, lap_count: int)
signal lap_started(lap: int)
signal race_over

func _process(delta: float) -> void:
	if lap_current:
		lap_current.time_tick(delta)

func _ready() -> void:
	area_entered.connect(func(area: Area2D):
		if area is Checkpoint:
			checkpoint = area
	)
