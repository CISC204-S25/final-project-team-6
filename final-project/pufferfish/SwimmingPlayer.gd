extends CharacterBody2D

@export var acceleration = 500.0 # acceleration in pixels/second/second
@export var max_velocity = 1000.0 # max velocity in pixels/second
@export var push_force = 100.0

@export var gravity = 900.0
@export var jump_force = 400.0
@onready var sprite = $AnimatedSprite2D
@onready var loadBar = $loadBar

var in_water: bool = true
@export var water_state_cooldown = 0.01 # in seconds
var water_state_timer = 0.0

var last_water_position: Vector2
@export var out_of_water_duration = 10.0 # seconds allowed out of water
var out_of_water_timer = 0.0

var pickedup: bool = false

var finsihedAnimation = false

var countdownText = 5

func pickup():
	pickedup = true

func letgo():
	pickedup = false

func _on_water_area_body_entered(body):
	$loadBar.hide()
	$SplashParticlesEnter.global_position = global_position
	$SplashParticlesEnter.restart()
	$SplashParticlesEnter.emitting = true
	$WaterSoundPlayer.play()
	if body == self and water_state_timer <= 0.0:
		in_water = true
		water_state_timer = water_state_cooldown
		last_water_position = global_position # Save current position
		out_of_water_timer = 0.0 # reset out-of-water timer
		sprite.modulate = Color(1, 1, 1)
		print("Entered water")

func _on_water_area_body_exited(body):
	_play_puffed()
	IsPuffed.puffed = true;
	$loadBar/countdown.text = "10"
	$loadBar.show()
	if body == self and water_state_timer <= 0.0:
		in_water = false
		water_state_timer = water_state_cooldown
		last_water_position = global_position # Save current position
		$SplashParticlesExit.global_position = global_position
		$SplashParticlesExit.restart()
		$SplashParticlesExit.emitting = true
		$WaterSoundPlayer.play()
		print("Sound playing: ", $WaterSoundPlayer.playing)
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
	_play_puffed()
	IsPuffed.puffed = true;
	$loadBar/countdown.text = "10"
	$loadBar.show()
	if water_state_timer <= 0.0:
		in_water = false
		water_state_timer = water_state_cooldown
		last_water_position = global_position # Save current position
	
func _on_bathroom_swimming() -> void:
	$loadBar.hide()
	if water_state_timer <= 0.0:
		in_water = true
		water_state_timer = water_state_cooldown
		last_water_position = global_position # Save current position
		out_of_water_timer = 0.0 # reset out-of-water timer
		sprite.modulate = Color(1, 1, 1)
	print("Entered water B")


func _on_bathroom_not_swimming() -> void:
	_play_puffed()
	$loadBar/countdown.text = "10"
	$loadBar.show()
	if water_state_timer <= 0.0:
		in_water = false
		water_state_timer = water_state_cooldown
		last_water_position = global_position # Save current position
	print("Exited water")	
	
func _on_bedroom_not_swimming() -> void:
	_play_puffed()
	$loadBar/countdown.text = "10"
	$loadBar.show()
	if water_state_timer <= 0.0:
		in_water = false
		water_state_timer = water_state_cooldown
		last_water_position = global_position # Save current position
	print("Exited water")	
	
func _on_party_room_not_swimming() -> void:
	_play_puffed()
	IsPuffed.puffed = true;
	$loadBar/countdown.text = "10"
	$loadBar.show()
	if water_state_timer <= 0.0:
		in_water = false
		water_state_timer = water_state_cooldown
		last_water_position = global_position # Save current position
	print("Exited water")	
	
func _on_party_room_swimming() -> void:
	$loadBar.hide()
	if water_state_timer <= 0.0:
		in_water = true
		water_state_timer = water_state_cooldown
		last_water_position = global_position # Save current position
		out_of_water_timer = 0.0 # reset out-of-water timer
		sprite.modulate = Color(1, 1, 1)
	print("Entered water")

func _ready() -> void:
	$AnimatedSprite2D.play("idle")
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
	
	if(Input.is_action_just_pressed("Puffing") && IsPuffed.puffed == false):
		IsPuffed.puffed = true;
		print("puffing")
		$AnimatedSprite2D.play("puffing_up")
		await get_tree().create_timer(.8).timeout
		$AnimatedSprite2D.play("puffed")
	elif(Input.is_action_just_pressed("Puffing") && IsPuffed.puffed == true):
		IsPuffed.puffed = false;
		print("not puffed")
		$AnimatedSprite2D.play_backwards("puffing_up")
		await get_tree().create_timer(.8).timeout
		$AnimatedSprite2D.play("idle")
		
#func _input(event: InputEvent) -> void:
	#if(event.is_action_pressed("Puffing") && IsPuffed.puffed == false):
		#IsPuffed.puffed = true;
		#$AnimatedSprite2D.play("puffing_up")
		#_on_animated_sprite_2d_animation_finished()
	#elif(event.is_action_pressed("Puffing") && IsPuffed.puffed == true):
		#IsPuffed.puffed = false;
		#$AnimatedSprite2D.play_backwards("puffing_up")
		#await get_tree().create_timer(3).timeout
		#$AnimatedSprite2D.play("idle")

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
		if($AnimatedSprite2D.animation == "swimming" || $AnimatedSprite2D.animation == "idle"):
			$AnimatedSprite2D.play("swimming")
		input_direction = input_direction.normalized()
		velocity += input_direction * acceleration * delta
		if input_direction.x != 0:
			sprite.scale.x = abs(sprite.scale.x) * sign(input_direction.x) * -1
	else:
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


func _on_animated_sprite_2d_animation_finished(delta) -> void:
	if($AnimatedSprite2D.animation == "puffing_up"):
		print("finsihed Animation")
		await get_tree().create_timer(.8).timeout
		$AnimatedSprite2D.play("puffed")
	else:
		$AnimatedSprite2D.play("swimming")

func _play_puffed() -> void:
	$AnimatedSprite2D.play("puffing_up")
	_on_animated_sprite_2d_animation_finished(get_process_delta_time())
	
