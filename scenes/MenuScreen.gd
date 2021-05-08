extends Control

onready var resultLabel: Label = $Result

var _allowPress := true

func _ready():
	resultLabel.text = ""
	Globals.connect("game_over", self, "_game_over")

func _on_Button_pressed():
	if _allowPress:
		visible = false
		Globals.createGameStuff()

func _game_over(fuel: float, score: int):
	resultLabel.text = "SCORE: " + str(score) + (" (out of fuel!)" if fuel <= 0 else " (out of time!)")
	visible = true
	Globals.removeGameStuff()
	
	_allowPress = false
	yield(get_tree().create_timer(0.5), "timeout")
	_allowPress = true
