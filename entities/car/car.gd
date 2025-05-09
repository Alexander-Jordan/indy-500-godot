class_name Car extends CharacterBody2D

@export_range(0, 1, 0.0001) var drag: float = 0.0020
@export var engine_power: float = 500.0
@export_range(0, 1, 0.01) var friction: float = 0.9
@export_enum('p1', 'p2') var player: String = 'p1'
@export var speed_reverse_max: float = 250.0
## Amount that front wheel turns, in degrees
@export var steering_angle_degrees: float = 15
@export var traction_min: float = 1.0
@export var traction_max: float = 10.0
## Distance from front to rear wheel.
@export var wheel_base: float = 10

var speed_min: float = 20
var speed_max: float = get_max_speed()
var steering_direction: float = 0.0

func _physics_process(delta: float) -> void:
	var acceleration: Vector2 = get_acceleration()
	steer()
	calculate_steering(delta)
	
	if acceleration.length() < speed_min and velocity.length() < speed_min:
		velocity = Vector2.ZERO
	velocity += acceleration * delta
	
	move_and_slide()

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

func get_acceleration() -> Vector2:
	var acceleration: Vector2 = Vector2.ZERO
	var input = -Input.get_axis(player + '_up', player + '_down')
	acceleration = transform.x * (engine_power * input)
	acceleration -= get_drag_force() + get_friction_force()
	return acceleration

func get_drag_force() -> Vector2:
	return velocity * velocity.length() * drag

func get_friction_force() -> Vector2:
	return velocity * friction

## Calculate and get the max speed from drag, friction, and engine_power.
## It's solving the quadratic equation (a*x^2) + (b*x) - c = 0
## a = drag, b = friction, c = engine_power, and x = velocity
## It solves it using the quadratic formula
## (-b + sqrt((b*b) + (4*a*c))) / (2*a)
func get_max_speed() -> float:
	var a: float = drag
	var b: float = friction
	var c: float = engine_power
	var discriminant = sqrt((b * b) + (4.0 * a * c))
	var velocity_magnitude_max = (-b + discriminant) / (2.0 * a)
	return velocity_magnitude_max

func get_traction() -> float:
	var normalized_slip: float = (velocity.length() - speed_min) / (speed_max - speed_min)
	normalized_slip = clampf(normalized_slip, 0.0, 1.0)
	return lerpf(traction_max, traction_min, normalized_slip)

func steer() -> void:
	var turn: float = Input.get_axis(player + '_left', player + '_right') # raw steering input
	steering_direction = turn * deg_to_rad(steering_angle_degrees)
