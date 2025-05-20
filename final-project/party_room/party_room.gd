extends Node2D
signal swimming
signal notSwimming
signal puffed_changed

var is_puffed = false

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
	pass


func _on_swimming_body_entered(body: Node2D) -> void:
	swimming.emit();


func _on_swimming_body_exited(body: Node2D) -> void:
	notSwimming.emit();


func _on_be_puffed_area_body_entered(body: Node2D) -> void:
	if(is_puffed == true):
		$HBoxContainer/SubViewportContainer/SubViewport1/level/background2.show()
		$HBoxContainer/SubViewportContainer/SubViewport1/level/lampStaticBody.hide()

func _on_exit_area_body_entered(body: Node2D) -> void:
	#leads back to the vent room
	pass # Replace with function body.


func _on_punch_bowl_area_body_entered(body: Node2D) -> void:
	swimming.emit();

func _on_puffed_changed(new_bool : bool):
	if new_bool:
		is_puffed = true
