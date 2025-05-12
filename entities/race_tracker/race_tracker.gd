class_name RaceTracker extends Area2D

@export var laps_max: int = 0

var checkpoint: Checkpoint = null:
	set(c):
		if laps.current == null:
			return
		
		# no previous checkpoint is set
		if checkpoint == null:
			if c.order_id == 0: # only set it if it's the first
				checkpoint = c
			return # otherwise, just ignore it
		
		# the new checkpoint is the next checkpoint in order
		# OR the new checkpoint is the previous checkpoint in order
		if c.order_id == checkpoint.order_id + 1 or c.order_id == checkpoint.order_id - 1:
			checkpoint = c
			laps.current.add_sector_from_checkpoint(c)
			return
	
		# not the next checkpoint by the normal order id, but by the secondary
		# this means that a lap has been completed
		if c.order_id_secondary == checkpoint.order_id + 1:
			checkpoint = c
			laps.new_lap()
var laps: Laps = Laps.new()

signal lap_ended(lap: Lap, lap_count: int)
signal lap_started(lap: int)
signal race_over

func _process(delta: float) -> void:
	if laps.current:
		laps.current.time_tick(delta)

func _ready() -> void:
	area_entered.connect(func(area: Area2D):
		if area is Checkpoint:
			checkpoint = area
	)
