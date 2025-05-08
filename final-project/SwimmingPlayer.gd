extends CharacterBody2D

@export var acceleration = 500.0 # acceleration in pixels/second/second
@export var max_velocity = 1000.0 # max velocity in pixels/second
@export var push_force = 100.0

@export var gravity = 900.0
@export var jump_force = 400.0
@onready var sprite = $AnimatedSprite2D

var in_water: bool = true
@export var water_state_cooldown = 0.01 # in seconds
var water_state_timer = 0.0

func _on_water_area_body_entered(body):
	if body == self and water_state_timer <= 0.0:
		in_water = true
		water_state_timer = water_state_cooldown
		print("Entered water")

func _on_water_area_body_exited(body):
	if body == self and water_state_timer <= 0.0:
		in_water = false
		water_state_timer = water_state_cooldown
		print("Exited water")

func _process(delta):
	if water_state_timer > 0.0:
		water_state_timer -= delta

func ground_movement(delta):
	$AnimatedSprite2D.play("puffing_up")
	$AnimatedSprite2D.play("puffed")
	var input_direction = Input.get_axis("FishLeft", "FishRight")
	velocity.x = lerp(velocity.x, input_direction * max_velocity, 0.1)

	velocity.y += gravity * delta
	if input_direction != 0:
		sprite.scale.x = abs(sprite.scale.x) * sign(input_direction) * -1

	if is_on_floor() and Input.is_action_just_pressed("FishUp"):
		velocity.y = -jump_force

func swim_movement(delta):
	var input_direction = Vector2(
		Input.get_axis("FishLeft", "FishRight"),
		Input.get_axis("FishUp", "FishDown")
	)

	if input_direction != Vector2.ZERO:
		$AnimatedSprite2D.play("swimming")
		input_direction = input_direction.normalized()
		velocity += input_direction * acceleration * delta
		if input_direction.x != 0:
			sprite.scale.x = abs(sprite.scale.x) * sign(input_direction.x) * -1
	else:
		$AnimatedSprite2D.play("idle")
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)

	if velocity.length() > max_velocity:
		velocity = velocity.normalized() * max_velocity

		
func _physics_process(delta):
	var input_direction = Vector2(
		Input.get_axis("FishLeft", "FishRight"),
		Input.get_axis("FishUp", "FishDown")
	)
	if in_water:
		swim_movement(delta)
	else:
		ground_movement(delta)

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
