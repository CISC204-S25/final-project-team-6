extends Node2D
signal swimming
signal notSwimming

@export_file("*.tscn") var target_scene: String




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_swimming_body_entered(body: Node2D) -> void:
	swimming.emit();


func _on_swimming_body_exited(body: Node2D) -> void:
	notSwimming.emit();


func _on_boat_area_body_entered(body: Node2D) -> void:
	if body.name == "pelican" and body.carrying_player:
		print("Pelican entered the boat! Teleporting..")
		get_tree().change_scene_to_file(target_scene)
	
