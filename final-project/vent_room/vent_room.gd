extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
