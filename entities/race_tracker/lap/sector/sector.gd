class_name Sector extends Resource

var finished: bool = false
var end_checkpoint_order_id: int = 1:
	set(e):
		end_checkpoint_order_id = start_checkpoint_order_id
	get:
		return start_checkpoint_order_id + 1
var start_checkpoint_order_id: int = 0:
	set(s):
		if s < 0 or s == start_checkpoint_order_id:
			return
		start_checkpoint_order_id = s
		end_checkpoint_order_id = s + 1
var time: float = 0.0

func _to_string() -> String:
	var minutes: int = int(time / 60)
	var seconds: int = int(int(time) % 60)
	var milliseconds: int = int((time - int(time)) * 1000)
	
	return "%d:%02d.%03d" % [minutes, seconds, milliseconds]

func set_from_other(other: Sector) -> Sector:
	finished = other.finished
	start_checkpoint_order_id = other.start_checkpoint_order_id
	time = other.time
	return self

func time_tick(delta: float) -> void:
	if finished:
		return
	
	time += delta

func to_best_sector(other: Sector) -> Sector:
	if other == null or time <= other.time:
		return self
	return set_from_other(other)
