extends CharacterBody2D

@export var acceleration = 500.0 # acceleration in pixels/second/second
@export var max_velocity = 1000.0 # max velocity in pixels/second
@export var push_force = 100.0
@onready var sprite = $AnimatedSprite2D

@export var pickup_distance = 140.0
var carrying_player = false
var swimming_player: CharacterBody2D
	
func _physics_process(delta):
	var swimming_player = get_node("../../../SubViewportContainer2/SubViewport2/pufferfish")
	var input_direction = Vector2(
		Input.get_axis("BirdLeft", "BirdRight"),
		Input.get_axis("BirdUp", "BirdDown")
	)
	
	if input_direction.x:
		sprite.play("walking")

	if input_direction.y:
		sprite.play("flying")

	if input_direction != Vector2.ZERO:
		input_direction = input_direction.normalized()
		velocity += input_direction * acceleration * delta
		# Flip sprite based on horizontal direction
		if input_direction.x != 0:
			$AnimatedSprite2D.flip_v = false
			# See the note below about the following boolean assignment.
			$AnimatedSprite2D.flip_h = velocity.x < 0
			#
			#sprite.scale.x = abs(sprite.scale.x) * sign(input_direction.x)
	else:
		# Optionally add friction or damping when not pressing input
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)

	# Clamp to max velocity
	if velocity.length() > max_velocity:
		velocity = velocity.normalized() * max_velocity
	
	if Input.is_action_just_pressed("BirdPickup") and not carrying_player and swimming_player:
		print("Pickup")
		if global_position.distance_to(swimming_player.global_position) < pickup_distance:
			print("In range")
			carrying_player = true
			swimming_player.pickup()
			swimming_player.set_physics_process(false) # Optional: disables their movement
	elif Input.is_action_just_pressed("BirdPickup") and carrying_player:
		print("Let Down")
		# Drop the player
		carrying_player = false
		swimming_player.letgo()
		swimming_player.set_physics_process(true) # Re-enable movement

	if carrying_player and swimming_player:
		var offset = Vector2(0, 140) # distance to the side
		swimming_player.global_position = global_position + offset
		swimming_player.visible = false # Hide while carried
	else:
		if swimming_player:
			swimming_player.visible = true # Show when dropped

	
	position += velocity * delta
	
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false


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
