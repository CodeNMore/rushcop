extends Node2D

onready var cam: Camera2D = $Cam

export var _shakeThresh: float = 0.1
export var _shakeBase: float = 0.015
export var _shakeLerp: float = 0.07

var _shakeAmount := 0.0

func _physics_process(delta):
	if _shakeAmount > _shakeThresh:
		cam.position = Vector2(rand_range(-_shakeBase, _shakeBase) * _shakeAmount, rand_range(-_shakeBase, _shakeBase) * _shakeAmount)
		_shakeAmount = lerp(_shakeAmount, 0, _shakeLerp)
	else:
		cam.position = Vector2.ZERO

func shake(amount: float):
	_shakeAmount += amount
