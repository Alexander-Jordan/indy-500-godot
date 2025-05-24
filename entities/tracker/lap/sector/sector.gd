class_name Sector extends Resource

@export var duration: float = 0.0
@export var has_finished: bool = false
@export var time: float = 0.0

var checkpoint_end: Checkpoint
var checkpoint_start: Checkpoint

signal finished(sector: Sector)

func _init(start: Checkpoint = null, end: Checkpoint = null):
	checkpoint_end = end
	checkpoint_start = start

func _to_string() -> String:
	var minutes: int = int(time / 60)
	var seconds: int = int(int(time) % 60)
	var milliseconds: int = int((time - int(time)) * 1000)
	
	return "%d:%02d.%03d" % [minutes, seconds, milliseconds]

func try_end_sector(start: Checkpoint, end: Checkpoint) -> void:
	if start != checkpoint_start or end != checkpoint_end:
		return
	has_finished = true
	finished.emit(self)

func set_from_other(other: Sector) -> Sector:
	duration = other.duration
	checkpoint_end = other.checkpoint_end
	checkpoint_start = other.checkpoint_start
	time = other.time
	return self

func time_tick(delta: float) -> void:
	if has_finished:
		return
	
	duration += delta
	time += delta

func to_best_sector(other: Sector) -> Sector:
	if other == null or time <= other.time:
		return self
	return set_from_other(other)
