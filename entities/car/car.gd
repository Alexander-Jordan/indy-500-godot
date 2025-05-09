class_name Car extends CharacterBody2D

@export var drag: float = 0.12
@export var engine_power: float = 500.0
@export var friction: float = 55
@export_enum('p1', 'p2') var player: String = 'p1'
@export var slip_speed: float = 200
@export var speed_reverse_max: float = 250.0
## Amount that front wheel turns, in degrees
@export var steering_angle_degrees: float = 15
@export var traction_fast: float = 2.5
@export var traction_slow: float = 10.0
## Distance from front to rear wheel.
@export var wheel_base: float = 10

var acceleration: Vector2 = Vector2.ZERO
var steering_direction: float = 0.0

func _physics_process(delta: float) -> void:
	drag_and_friction(delta)
	calculate_steering(delta)
	velocity += acceleration * delta
	move_and_slide()

func _process(delta: float) -> void:
	accelerate()
	steer()

func accelerate() -> void:
	acceleration = Vector2.ZERO
	var input = -Input.get_axis(player + '_up', player + '_down')
	acceleration = transform.x * (engine_power * input)

func calculate_steering(delta: float) -> void:
	# Find the wheel positions
	var rear_wheel: Vector2 = position - transform.x * wheel_base / 2.0
	var front_wheel: Vector2 = position + transform.x * wheel_base / 2.0
	# Move the wheel forward
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steering_direction) * delta
	# Find the new direction vector
	var new_heading: Vector2 = rear_wheel.direction_to(front_wheel)
	# Set traction
	var traction: float = get_traction()
	# Set the velocity to the new direction, depending on forward or backward
	var d: float = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)
	if d < 0:
		velocity = lerp(velocity, -new_heading * minf(velocity.length(), speed_reverse_max), traction * delta)
	# Set the rotation to the new direction
	rotation = new_heading.angle()

func drag_and_friction(delta: float) -> void:
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	var friction_force: Vector2 = -velocity * friction * delta
	var drag_force: Vector2 = -velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force

func get_traction() -> float:
	var slip_speed_min: float = 50
	var slip_speed_max: float = 320
	var traction_min: float = 1.0
	var traction_max: float = 10.0
	
	var normalized_slip: float = (velocity.length() - slip_speed_min) / (slip_speed_max - slip_speed_min)
	normalized_slip = clampf(normalized_slip, 0.0, 1.0)
	
	return lerpf(traction_max, traction_min, normalized_slip)

func steer() -> void:
	var turn: float = Input.get_axis(player + '_left', player + '_right') # raw steering input
	steering_direction = turn * deg_to_rad(steering_angle_degrees)
