extends Area2D

func _on_Goal_body_entered(body):
	if body.is_in_group("player"):
		Globals.emit_signal("goal_collected")
		body.addScore(1)
		queue_free()
