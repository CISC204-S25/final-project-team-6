extends Area2D

var characters_in_water := []

func _on_body_entered(body):
	print("Entered:", body.name)
	if body.name == "SwimmingPlayer":
		characters_in_water.append(body)
	elif body.name == "FlyingPlayer":
		body.global_position = body.global_position + Vector2(0, -50) # push them out
		# Optional: or disable movement
		body.set_physics_process(false)

func _on_body_exited(body):
	if body.name == "SwimmingPlayer":
		var direction_to_center = (global_position - body.global_position).normalized()
		body.velocity = direction_to_center * 100
	elif body.name == "FlyingPlayer":
		body.set_physics_process(true)
