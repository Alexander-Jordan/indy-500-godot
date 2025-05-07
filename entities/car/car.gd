class_name Car extends CharacterBody2D

@export var acceleration_drag_rate: float = 50.0
@export var acceleration_max: float = 10000.0
@export var acceleration_throttle_rate: float = 250.0
@export_enum('p1', 'p2') var player: String = 'p1'
@export var rotation_speed: int = 5

var acceleration: float = 0.0
var collision: KinematicCollision2D = null
var steering: float = 0.0

func _physics_process(delta: float) -> void:
	collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		acceleration = collision.get_remainder().length()

func _process(delta: float) -> void:
	throttle()
	drag()
	steer()
	
	rotation += rotation_speed * steering * delta
	if !collision:
		velocity = Vector2(acceleration * delta, 0).rotated(rotation)

func drag() -> void:
	var drag_direction: float = -1.0 if acceleration > 0 else 1.0
	acceleration += drag_direction * acceleration_drag_rate

func steer() -> void:
	steering = Input.get_axis(player + '_left', player + '_right') # raw steering input
	steering = steering if acceleration > 0 else -steering # invert steering when reversing
	steering *= abs(acceleration / acceleration_max) # clamp to acceleration

func throttle() -> void:
	var throttle_direction: float = -Input.get_axis(player + '_up', player + '_down') # raw throttle input
	# clamp acceleration
	if (throttle_direction > 0 and acceleration < acceleration_max) or (throttle_direction < 0 and acceleration > -acceleration_max):
		acceleration += throttle_direction * acceleration_throttle_rate # increase acceleration at rate
