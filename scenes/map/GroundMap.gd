class_name GroundMap
extends TileMap

const pFuel := preload("res://scenes/items/Fuel.tscn")
const pGoal := preload("res://scenes/items/Goal.tscn")

onready var spawnPointNodes = $SpawnPoints.get_children()
onready var goalTimer: Timer = $GoalTimer

export var goalTimeLimit: float = 40.0

var curFuelPos := Vector2()
var curGoalPos := Vector2()

func _ready():
	randomize()
	_spawnFuel()
	_spawnGoal()
	Globals.connect("fuel_collected", self, "_fuel_collected")
	Globals.connect("goal_collected", self, "_goal_collected")

func _getSpawnPos(except: Array) -> Vector2:
	var node: Node2D = spawnPointNodes[randi() % spawnPointNodes.size()]
	while except.has(node.global_position):
		node = spawnPointNodes[randi() % spawnPointNodes.size()]
	return node.global_position

func _spawnFuel():
	curFuelPos = _getSpawnPos([curFuelPos, curGoalPos])
	var fuel = pFuel.instance()
	fuel.global_position = curFuelPos
	add_child(fuel)
	
func _spawnGoal():
	curGoalPos = _getSpawnPos([curFuelPos, curGoalPos])
	var goal = pGoal.instance()
	goal.global_position = curGoalPos
	add_child(goal)
	goalTimer.start(goalTimeLimit)

func _fuel_collected():
	curFuelPos = Vector2()
	_spawnFuel()
	
func _goal_collected():
	curGoalPos = Vector2()
	_spawnGoal()

func _on_GoalTimer_timeout():
	Globals.emit_signal("game_over", Globals.getPlayer().fuel, Globals.getPlayer().score)
