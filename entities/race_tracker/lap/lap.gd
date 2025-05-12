class_name Lap extends Resource

var sectors: Array[Sector] = [Sector.new()]
var time: float

func add_sector_from_checkpoint(checkpoint: Checkpoint) -> void:
	if checkpoint.order_id != sectors[-1].end_checkpoint_order_id:
		return
	sectors.append(Sector.new(checkpoint.order_id, checkpoint.order_id + 1))

func time_tick(delta: float) -> void:
	time += delta
	sectors[-1].time_tick(delta)
