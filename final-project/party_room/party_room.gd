extends Node2D
signal swimming
signal notSwimming




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


func _on_be_puffed_area_body_entered(body: Node2D) -> void:
	if(PufferFish.puffed == true):
		$background2.show()
		$lampStaticBody.hide()


func _on_pick_up_item_body_entered(body: Node2D) -> void:
	$PickUpItem/Item.hide()
	$InvisbleStaticBody.hide()


func _on_exit_area_body_entered(body: Node2D) -> void:
	#leads back to the vent room
	pass # Replace with function body.


func _on_punch_bowl_area_body_entered(body: Node2D) -> void:
	swimming.emit();
