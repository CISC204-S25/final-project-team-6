extends CharacterBody2D

@export var acceleration = 500.0 # acceleration in pixels/second/second
@export var max_velocity = 1000.0 # max velocity in pixels/second
@export var push_force = 100.0

@export var gravity = 900.0
@export var jump_force = 400.0
@onready var sprite = $AnimatedSprite2D
@onready var loadBar = $loadBar

@export var puffed = false
signal puffed_changed(new_value: bool)

var in_water: bool = true
@export var water_state_cooldown = 0.01 # in seconds
var water_state_timer = 0.0

var last_water_position: Vector2
@export var out_of_water_duration = 10.0 # seconds allowed out of water
var out_of_water_timer = 0.0

var pickedup: bool = false

var countdownText = 5

func pickup():
	pickedup = true

func letgo():
	pickedup = false

func _on_water_area_body_entered(body):
	$loadBar.hide()
	if body == self and water_state_timer <= 0.0:
		in_water = true
		water_state_timer = water_state_cooldown
		last_water_position = global_position # Save current position
		out_of_water_timer = 0.0 # reset out-of-water timer
		sprite.modulate = Color(1, 1, 1)
		print("Entered water")

func _on_water_area_body_exited(body):
	if(Input.is_action_just_pressed("Puffing") && puffed == false):
		puffed = true;
		$AnimatedSprite2D.play("puffing_up")
	elif(Input.is_action_just_pressed("Puffing") && puffed == true):
		puffed = false;
		$AnimatedSprite2D.play_backwards("puffing_up")
		
	$loadBar/countdown.text = "10"
	$loadBar.show()
	if body == self and water_state_timer <= 0.0:
		in_water = false
		water_state_timer = water_state_cooldown
		last_water_position = global_position # Save current position
		print("Exited water")
		
#For game level
func _on_level_swimming() -> void:
	$loadBar.hide()
	if water_state_timer <= 0.0:
		in_water = true
		water_state_timer = water_state_cooldown
		last_water_position = global_position # Save current position
		out_of_water_timer = 0.0 # reset out-of-water timer
		sprite.modulate = Color(1, 1, 1)
	print("Entered water")
		


func _on_level_not_swimming() -> void:
	$AnimatedSprite2D.play("puffing_up")
	$loadBar/countdown.text = "10"
	$loadBar.show()
	if water_state_timer <= 0.0:
		in_water = false
		water_state_timer = water_state_cooldown
		last_water_position = global_position # Save current position
	print("Exited water")
	

func _ready() -> void:
	loadBar.value = out_of_water_duration
	loadBar.hide()



func _process(delta):
	if water_state_timer > 0.0:
		water_state_timer -= delta
	
	if not in_water and not pickedup:
		out_of_water_timer += delta
		$loadBar.value = out_of_water_timer
		$loadBar/countdown.text = str(out_of_water_duration - round(out_of_water_timer))
		# Flash red if timer is near end (last 1 second)
		if out_of_water_duration - out_of_water_timer <= 3.0:
			# Flashing effect using sine wave
			var flash_intensity = sin(2 * PI * 5 * out_of_water_timer) * 0.5 + 0.5 # from 0 to 1
			sprite.modulate = Color(1, 1 - flash_intensity, 1 - flash_intensity) # red tint
		else:
			sprite.modulate = Color(1, 1, 1) # normal
		
		if out_of_water_timer >= out_of_water_duration:
			global_position = last_water_position
			velocity = Vector2.ZERO
			out_of_water_timer = 0.0
	else:
		out_of_water_timer = 0.0

func ground_movement(delta):
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


func _on_animated_sprite_2d_animation_finished() -> void:
	print("finsihed Animation")
	if($AnimatedSprite2D.animation == "puffing_up"):
		$AnimatedSprite2D.play(("puffed"))
	else:
		$AnimatedSprite2D.stop()

func _is_puffed() -> void:
	if(Input.is_action_just_pressed("Puffing") && puffed == false):
		emit_signal("puffed_changed", puffed_changed)
		puffed = true;
		$AnimatedSprite2D.play("puffing_up")
	elif(Input.is_action_just_pressed("Puffing") && puffed == true):
		emit_signal("puffed_changed", puffed_changed)
		puffed = false;
		$AnimatedSprite2D.play_backwards("puffing_up")
