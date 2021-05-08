extends Node

const FUEL_AMT: float = 0.5
const pPlayer := preload("res://scenes/player/Player.tscn")
const pMap := preload("res://scenes/map/GroundMap.tscn")

signal player_fuel_changed(fuel)
signal player_score_changed(score)
signal fuel_collected()
signal goal_collected()
signal game_over(fuel, score)

func getPlayer() -> Player:
	return get_tree().current_scene.find_node("Player", true, false) as Player

func getGroundMap() -> GroundMap:
	return get_tree().current_scene.find_node("GroundMap", true, false) as GroundMap

func removeGameStuff():
	getPlayer().queue_free()
	getGroundMap().queue_free()
	
func createGameStuff():
	var map = pMap.instance()
	map.name = "GroundMap"
	
	var player = pPlayer.instance()
	player.name = "Player"
	
	get_tree().current_scene.add_child(map)
	get_tree().current_scene.add_child(player)

func toZero(val: float, amt: float) -> float:
	if val > 0:
		val -= amt
		if val < 0:
			val = 0
	elif val < 0:
		val += amt
		if val > 0:
			val = 0
	return val
