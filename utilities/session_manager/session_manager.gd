class_name SessionManager extends Node

var finished: Array[Tracker] = []

func _ready() -> void:
	GM.reset.connect(reset)

func add_finished(tracker: Tracker) -> int:
	finished.append(tracker)
	if finished.size() == GM.players:
		GM.state = GM.State.FINISHED
	return finished.size()

func reset() -> void:
	finished = []
