extends Control

onready var fuelBar: ProgressBar = $FuelBar
onready var scoreLabel: Label = $ScoreLabel
onready var timeLabel: Label = $TimeLabel

func _ready():
	Globals.connect("player_fuel_changed", self, "_player_fuel_changed")
	Globals.connect("player_score_changed", self, "_player_score_changed")
	
func _process(delta):
	var map: GroundMap = Globals.getGroundMap()
	if map:
		visible = true
		timeLabel.text = "Time to stop crime: " + str(stepify(map.goalTimer.time_left, 0.1))
	else:
		visible = false
	
func _player_fuel_changed(fuel: float):
	fuelBar.value = fuel

func _player_score_changed(score: int):
	scoreLabel.text = "Score: " + str(score)
