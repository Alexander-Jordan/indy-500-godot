class_name SlowerArea extends Area2D

const FRICTION_NORMAL: float = 0.9
const FRICTION_SLOW: float = 10.0

var cars: Array[Car] = []

func _ready() -> void:
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	GM.reset.connect(reset)

func on_body_entered(body: Node2D) -> void:
	if body is Car:
		body.properties.friction = FRICTION_SLOW
		if !cars.has(body):
			cars.append(body)

func on_body_exited(body: Node2D) -> void:
	if body is Car:
		body.properties.friction = FRICTION_NORMAL
		if !cars.has(body):
			cars.erase(body)

func reset() -> void:
	for car in cars:
		car.properties.friction = FRICTION_NORMAL
	cars = []
