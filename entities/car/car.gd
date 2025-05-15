@tool
class_name Car extends CharacterBody2D

@export_enum('p1', 'p2') var player: String = 'p1'
@export var properties: CarProperties
@export var sprite: CompressedTexture2D:
	set(s):
		if s == sprite:
			return
		sprite = s
		if sprite_2d:
			sprite_2d.texture = sprite

@onready var race_tracker: RaceTracker = $RaceTracker
@onready var spawn_position: Vector2 = position
@onready var spawn_rotation: float = rotation
@onready var sprite_2d: Sprite2D = $Sprite2D

var acceleration_input: float = 0.0
var steering_input: float = 0.0

func _physics_process(delta: float) -> void:
	# Don't run any code from this function in the editor
	if Engine.is_editor_hint():
		return
	
	properties.acceleration = get_acceleration()
	properties.steering = get_steering()
	calculate_steering(delta)
	
	if properties.acceleration.length() < properties.speed_min and velocity.length() < properties.speed_min:
		velocity = Vector2.ZERO
	velocity += properties.acceleration * delta
	
	move_and_slide()

func _process(_delta: float) -> void:
	# Don't run any code from this function in the editor
	if Engine.is_editor_hint():
		return
	
	acceleration_input = get_acceleration_input()
	steering_input = get_steer_input()

func _ready() -> void:
	# Don't run any code from this function in the editor
	if Engine.is_editor_hint():
		return
	
	sprite_2d.texture = sprite
	
	GM.players_changed.connect(func(players: int):
		if player == 'p2':
			if players == 1:
				disable()
			else:
				enable()
	)
	GM.reset.connect(reset)
	race_tracker.laps.best_changed.connect(func(best: Lap): print('[%s] Best: ' % [player], best))
	race_tracker.laps.finished.connect(func(laps: Laps): print('[%s] Finished!\n' % player, laps))
	race_tracker.laps.lap_ended.connect(func(lap: Lap, lap_count: int): print('[%s] L%s: ' % [player, str(lap_count)], lap))
	race_tracker.laps.lap_started.connect(func(_lap: Lap, number: int): print('[%s] L%s started' % [player, str(number)]))
	race_tracker.laps.optimal_changed.connect(func(optimal: Lap): print('[%s] Optimal:' % [player], optimal))

func calculate_steering(delta: float) -> void:
	# Find the wheel positions
	var rear_wheel: Vector2 = position - transform.x * properties.wheel_base / 2.0
	var front_wheel: Vector2 = position + transform.x * properties.wheel_base / 2.0
	# Move the wheel forward
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(properties.steering) * delta
	# Find the new direction vector
	var new_heading: Vector2 = rear_wheel.direction_to(front_wheel)
	# Set traction
	var traction: float = get_traction()
	# Set the velocity to the new direction, depending on forward or backward
	var d: float = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = lerp(velocity, new_heading * minf(velocity.length(), properties.speed_max), traction * delta)
	if d < 0:
		velocity = lerp(velocity, -new_heading * minf(velocity.length(), properties.speed_reverse_max), traction * delta)
	# Set the rotation to the new direction
	rotation = new_heading.angle()

func disable() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func enable() -> void:
	show()
	process_mode = Node.PROCESS_MODE_INHERIT

func get_acceleration() -> Vector2:
	var new_acceleration: Vector2 = transform.x * (properties.engine_power * acceleration_input)
	new_acceleration -= get_drag_force() + get_friction_force()
	return new_acceleration

func get_acceleration_input() -> float:
	return -Input.get_axis(player + '_up', player + '_down') if GM.state == GM.State.RACING else 0.0

func get_drag_force() -> Vector2:
	return velocity * velocity.length() * properties.drag

func get_friction_force() -> Vector2:
	return velocity * properties.friction

func get_steering() -> float:
	return steering_input * deg_to_rad(properties.steering_angle_degrees_max)

func get_steer_input() -> float:
	return Input.get_axis(player + '_left', player + '_right') if GM.state == GM.State.RACING else 0.0

func get_traction() -> float:
	var normalized_slip: float = (velocity.length() - properties.speed_min) / (properties.speed_max - properties.speed_min)
	normalized_slip = clampf(normalized_slip, 0.0, 1.0)
	return properties.traction_curve.sample(normalized_slip)

func reset() -> void:
	race_tracker.reset()
	velocity = Vector2.ZERO
	properties.acceleration = Vector2.ZERO
	position = spawn_position
	rotation = spawn_rotation
