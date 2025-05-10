@tool
class_name CarProperties extends Resource

@export_group('Force constants')
@export_range(0, 0.01, 0.0001) var drag: float = 0.002
@export_range(100, 1000, 10) var engine_power: float = 500.0
@export_range(0, 10, 0.01) var friction: float = 0.9
@export_group('Speed', 'speed_')
@export var speed_min: float = 20
@export var speed_max: float = get_max_speed()
@export_tool_button('Recalculate max speed') var speed_recalculate_max_speed: Callable = func():
	speed_max = get_max_speed()
@export_range(50, 500, 5) var speed_reverse_max: float = 250.0
@export_group('Steering', 'steering_')
## Amount that front wheel turns, in degrees
@export_range(2, 20, 1) var steering_angle_degrees_max: float = 15
@export_group('Traction', 'traction_')
@export var traction_curve: Curve
@export_group('Wheels', 'wheel_')
## Distance from front to rear wheel.
@export_range(8, 32, 1) var wheel_base: float = 10

var acceleration: Vector2 = Vector2.ZERO
var steering: float = 0.0

## Calculate and get the max speed (velocity magnitude) from drag, friction, and engine_power.
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
