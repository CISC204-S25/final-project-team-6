extends CanvasLayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#ProjectSettings.set_setting("display/window/size/window_width_override", 1100)
	#ProjectSettings.set_setting("display/window/size/window_height_override", 300)
	
	get_window().size = Vector2i(1050, 600)
	
	$seaweed.play("default")
	$seaweed2.play("default")
	$AnimatedSprite2D.play("start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://startGame/IntroStory.tscn")
