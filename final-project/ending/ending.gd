extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_window().size = Vector2i(2420, 1668)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_window().size = Vector2i(2420, 1668)
