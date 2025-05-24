class_name Tracker extends Area2D

@onready var tracker_audio_stream_player_2d: TrackerAudioStreamPlayer2D = $TrackerAudioStreamPlayer2D

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

signal finished(place: int)
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
	laps.finished.connect(on_laps_finished)
	laps.sector_ended.connect(on_sector_ended)

func on_laps_finished(_laps: Laps) -> void:
	tracker_audio_stream_player_2d.on_session_finished()
	var place: int = SM.add_finished(self)
	finished.emit(place)

func on_sector_ended(_sector: Sector, number: int) -> void:
	if number < laps.max_laps:
		tracker_audio_stream_player_2d.on_sector_finished()
	else:
		tracker_audio_stream_player_2d.on_lap_finished()

func reset() -> void:
	laps.reset()
	laps.max_laps = GM.race_settings.laps
	checkpoint = null
