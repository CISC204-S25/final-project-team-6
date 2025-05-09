extends Sprite2D
var Dialogue 
var currentString = 0 
@export var isTyping = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogue = ["(Press space to read)", 
	"There was once a summer so hot, even the fish begged for cold water.",
	"A pelican and a fish met up with each other just to complain.",
	"In the middle of their conversation a huge cruise ship appeared in " + 
	"front of them.The ship had many humans who clearly weren't affected by " +
	"the sun's death rays.", "The fish and pelican then devised a plan to " +
	"create a vacation of their own, by taking things from the humans." ]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite2D/Label.show()
	if Input.is_action_just_pressed("Space") and not isTyping:
		currentString = currentString + 1
		
		if currentString >= Dialogue.size():
			currentString= 0
		type_letters()
	
		
		
func type_letters(): 
	$Sprite2D/Label.text = ""
	for letter in Dialogue[currentString]:
		$Sprite2D/Label.text = $Sprite2D/Label.text + letter
		await get_tree().create_timer(0.02).timeout
		isTyping = true
	isTyping = false
