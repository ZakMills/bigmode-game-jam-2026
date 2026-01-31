extends Control

@onready var screen_size = get_viewport_rect().size
@onready var camera = get_tree().get_root().get_node("Main").get_node("PC").get_node("Camera2D")
#@onready var camera = get_tree().get_root().get_node("Main").get_node("Camera2D")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#position.x = pc. screen_size
	#print($Background.visible, "    ", $Background.color)
	#position.x = camera.get_target_position().x-screen_size.x/2
	#position.y = camera.get_target_position().y-screen_size.y/2
	
	pass
	
func score_update():
	$ScoreValue.text = str(Global.score)
	
	pass
