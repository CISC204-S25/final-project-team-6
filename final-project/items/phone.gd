extends Area2D

var gotPhone = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_animation("AnimatedSprite2D", "spinning")

func _on_body_entered(body: Node2D) -> void:
	gotPhone = true
	$".".hide()

func play_animation(sprite_name: String, animation_name: String):
	var animated_sprite = get_node(sprite_name)
	if animated_sprite:
		animated_sprite.play(animation_name)
