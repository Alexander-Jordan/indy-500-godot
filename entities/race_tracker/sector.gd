class_name Sector extends Resource

var end_checkpoint_order_id: int = 1
var start_checkpoint_order_id: int = 0
var time: float = 0.0

func _init(start: int = 0, end: int = 1) -> void:
	start_checkpoint_order_id = start
	end_checkpoint_order_id = end

func time_tick(delta: float) -> void:
	time += delta
