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
	print("entered");


func _on_swimming_body_exited(body: Node2D) -> void:
	notSwimming.emit();
	print("exited");
