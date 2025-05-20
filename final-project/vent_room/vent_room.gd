extends Node2D

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Use for later
	#if(gotBedroomItem == true):
		#$Stopper1.hide()
	#if(gotPartyRoomItem == true):
		#$Stopper2.hide()
	pass



func _on_party_room_area_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://party_room/party_room.tscn")


func _on_bathroom_area_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://bedroom/bedroom.tscn")
