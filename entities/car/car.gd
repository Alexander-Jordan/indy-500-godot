class_name Car extends CharacterBody2D

@export var acceleration_drag_rate: float = 50.0
@export var acceleration_max: float = 10000.0
@export var acceleration_throttle_rate: float = 250.0
@export_enum('p1', 'p2') var player: String = 'p1'
@export var rotation_speed: int = 5

var acceleration: float = 0.0
var steering: float = 0.0
var throttle_direction: float = 0.0

func _process(delta: float) -> void:
	drag()
	steer()
	throttle()
	
	rotation += rotation_speed * steering * delta
	velocity = Vector2(acceleration * delta, 0).rotated(rotation)
	
	move_and_slide()

func drag() -> void:
	var drag_influence: float = 1 - abs(throttle_direction)
	var drag_direction: float = -drag_influence if acceleration > 0 else drag_influence
	acceleration += drag_direction * acceleration_drag_rate

func steer() -> void:
	steering = Input.get_axis(player + '_left', player + '_right') # raw steering input
	steering = steering if acceleration > 0 else -steering # invert steering when reversing
	steering *= abs(acceleration / acceleration_max) # clamp to acceleration

func throttle() -> void:
	throttle_direction = -Input.get_axis(player + '_up', player + '_down') # raw throttle input
	# clamp acceleration
	if (throttle_direction > 0 and acceleration < acceleration_max) or (throttle_direction < 0 and acceleration > -acceleration_max):
		acceleration += throttle_direction * acceleration_throttle_rate # increase acceleration at rate
