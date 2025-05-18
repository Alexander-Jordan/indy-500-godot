class_name Checkpoints extends Node2D

const CHECKPOINTS_AMOUNT = 4

@export var loop: bool = true

var all: Array[Checkpoint] = []
var first: Checkpoint = null
var second: Checkpoint = null
var third: Checkpoint = null
var forth: Checkpoint = null

func _ready() -> void:
	set_checkpoints_from_children()

func get_next(from: Checkpoint) -> Checkpoint:
	match from:
		null:
			return first
		first:
			return second
		second:
			return third
		third:
			return first if loop else forth
		_:
			return null

func get_previous(from: Checkpoint) -> Checkpoint:
	match from:
		second:
			return first
		third:
			return second
		forth:
			return third
		_:
			return null

func set_checkpoints_from_children() -> void:
	var children: Array[Node] = get_children()
	for index in children.size():
		var child: Node = children[index]
		if child is not Checkpoint:
			assert(false, 'Only Checkpoint nodes are allowed as children to Checkpoints node.')
			return
		if loop and index >= CHECKPOINTS_AMOUNT:
			assert(false, 'Max %d Checkpoint nodes are allowed as children to a looped Checkpoints node.' % (CHECKPOINTS_AMOUNT - 1))
			return
		if !loop and index >= CHECKPOINTS_AMOUNT:
			assert(false, 'Max %d Checkpoint nodes are allowed as children to a Checkpoints node.' % CHECKPOINTS_AMOUNT)
			return
		match index:
			0:
				first = child
			1:
				second = child
			2:
				third = child
			3:
				forth = child
