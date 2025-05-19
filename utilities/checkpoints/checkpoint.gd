class_name Checkpoint extends Area2D

var checkpoints: Checkpoints = null

func _ready() -> void:
	set_checkpoint_system_from_parent()

func get_next() -> Checkpoint:
	return checkpoints.get_next(self)

func get_previous() -> Checkpoint:
	return checkpoints.get_previous(self)

func set_checkpoint_system_from_parent() -> void:
	var parent: Node = get_parent()
	if parent is not Checkpoints:
		assert(false, 'A Checkpoint node requires a Checkpoints node as a parent.')
		return
	checkpoints = parent
