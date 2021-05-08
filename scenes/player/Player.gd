class_name Player
extends KinematicBody2D

onready var dirSprite: Sprite = $DirSprite
onready var goalSprite: Sprite = $GoalSprite
onready var fuelSprite: Sprite = $FuelSprite
onready var _hintHideDist: float = get_viewport_rect().end.x / 2.0 * $CamContainer/Cam.zoom.x # ehh
onready var camCont = $CamContainer

export var _accel: float = 80.0
export var _decel: float = 130.0
export var _maxSpeed: float = 150.0
export var _turnLerp: float = 0.05
export var _fuelExpendatureRate: float = 0.04

var _inputDir: int = 0
var _inputAngle: float = 0
var _speed: float = 0
var _vel := Vector2()

var fuel: float = 1
var score: int = 0

func _ready():
	addFuel(0)
	addScore(0)
	global_position = Globals.getGroundMap()._getSpawnPos([])

func _process(delta: float):
	_getInput()
	
	dirSprite.rotation = _inputAngle + deg2rad(90) - rotation
	
	var map: GroundMap = Globals.getGroundMap()
	goalSprite.rotation = global_position.direction_to(map.curGoalPos).angle() + deg2rad(90) - rotation
	goalSprite.visible = (global_position.distance_to(map.curGoalPos) > _hintHideDist)
	fuelSprite.rotation = global_position.direction_to(map.curFuelPos).angle() + deg2rad(90) - rotation
	fuelSprite.visible = (global_position.distance_to(map.curFuelPos) > _hintHideDist)

func _physics_process(delta):
	_changeVel(delta)
	_vel = move_and_slide(_vel, Vector2.ZERO)
	camCont.shake(clamp(_speed - _vel.length(), 0, 1000))
	_speed = _vel.length() * sign(_speed)
	
func _changeVel(delta: float):
	if _inputDir < 0 and _speed <= 0 and fuel > 0:
		_speed -= _accel * delta
		addFuel(-_fuelExpendatureRate * delta)
	elif _inputDir > 0 and _speed >= 0 and fuel > 0:
		_speed += _accel * delta
		addFuel(-_fuelExpendatureRate * delta)
	elif _speed != 0:
		_speed = Globals.toZero(_speed, _decel * delta)
	
	if _speed != 0:
		rotation = lerp_angle(rotation, _inputAngle, _turnLerp)
		
	_speed = clamp(_speed, -_maxSpeed / 2.0, _maxSpeed)
	_vel = Vector2(cos(rotation), sin(rotation)) * _speed
	
func _getInput():
	if Input.is_action_pressed("gas_forward"):
		_inputDir = 1
	elif Input.is_action_pressed("gas_backward"):
		_inputDir = -1
	else:
		_inputDir = 0
		
	_inputAngle = global_position.direction_to(get_global_mouse_position()).angle()

func addFuel(amt: float):
	fuel += amt
	fuel = clamp(fuel, 0, 1)
	if fuel <= 0:
		Globals.emit_signal("game_over", fuel, score)
	Globals.emit_signal("player_fuel_changed", fuel)

func addScore(amt: int):
	score += amt
	Globals.emit_signal("player_score_changed", score)
