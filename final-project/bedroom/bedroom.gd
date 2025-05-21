extends Node2D
signal swimming
signal notSwimming

@onready var players := {
	"1": {
		viewport = $"HBoxContainer/SubViewportContainer/SubViewport1",
		camera = $"HBoxContainer/SubViewportContainer/SubViewport1/Camera2D1",
		player = $HBoxContainer/SubViewportContainer/SubViewport1/pelican,
	},
	"2" : {
		viewport = $"HBoxContainer/SubViewportContainer2/SubViewport2",
		camera = $"HBoxContainer/SubViewportContainer2/SubViewport2/Camera2D2",
		player = $HBoxContainer/SubViewportContainer2/SubViewport2/pufferfish,
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	players["2"]["viewport"].world_2d = players["1"]["viewport"].world_2d
	for node in players.values():
			var remote_transform := RemoteTransform2D.new()
			remote_transform.remote_path = node["camera"].get_path()
			node["player"].add_child(remote_transform)
	
	# --- AUTO PICKUP LOGIC ---
	var pelican = players["1"]["player"]
	var pufferfish = players["2"]["player"]

	# Set carrying_player flag
	pelican.carrying_player = true

	# Call the same pickup behavior used in _physics_process
	pufferfish.pickup()
	pufferfish.set_physics_process(false)
	pufferfish.visible = false

	# Manually position the pufferfish correctly
	pufferfish.global_position = pelican.global_position + Vector2(0, 140)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pelican = players["1"]["player"]
	var pufferfish = players["2"]["player"]
	
	if pelican.carrying_player == false:
		notSwimming.emit();



func _on_vent_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://vent_room/vent_room.tscn")


func _on_soda_body_entered(body: Node2D) -> void:
	$HBoxContainer/SubViewportContainer/SubViewport1/Level/Soda.hide();
