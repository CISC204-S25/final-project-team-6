extends Node2D
signal swimming
signal notSwimming


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sky/seaweed.play("default");
	$Sky/seaweed2.play("default");
	$Sky/seaweed3.play("default");
	$Sky/seaweed4.play("default");
	$Sky/seaweed5.play("default");
	$Sky/seaweed6.play("default");
	$Sky/seaweed7.play("default");
	$Sky/seaweed8.play("default");
	$Sky/seaweed9.play("default");
	$Sky/seaweed10.play("default");
	$Sky/seaweed11.play("default");
	$Sky/seaweed12.play("default");
	$Sky/seaweed13.play("default");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_swimming_body_entered(body: Node2D) -> void:
	swimming.emit();


func _on_swimming_body_exited(body: Node2D) -> void:
	notSwimming.emit();
