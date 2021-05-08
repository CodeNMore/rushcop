extends Area2D

func _on_Fuel_body_entered(body):
	if body.is_in_group("player"):
		Globals.emit_signal("fuel_collected")
		body.addFuel(Globals.FUEL_AMT)
		queue_free()
