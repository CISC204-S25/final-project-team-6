extends CharacterBody2D

@export var acceleration = 500.0 # acceleration in pixels/second/second
@export var max_velocity = 1000.0 # max velocity in pixels/second
@export var push_force = 100.0

func _physics_process(delta):
	var input_direction = Vector2(
		Input.get_axis("BirdLeft", "BirdRight"),
		Input.get_axis("BirdUp", "BirdDown")
	)

	if input_direction != Vector2.ZERO:
		input_direction = input_direction.normalized()
		velocity += input_direction * acceleration * delta
	else:
		# Optionally add friction or damping when not pressing input
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)

	# Clamp to max velocity
	if velocity.length() > max_velocity:
		velocity = velocity.normalized() * max_velocity

	move_and_slide()
	push_objects()

func push_objects():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			collider.apply_central_impulse(collision.get_normal() * -1 * push_force)
		elif collider is StaticBody2D:
			velocity = Vector2.ZERO
