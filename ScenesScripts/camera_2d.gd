extends Camera2D

#@onready var main = get_tree().get_root().get_node("Main")
#@onready var top_ribbon = main.get_node("TopRibbon")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var drag_margin : float = 0.5
	set_drag_margin(SIDE_TOP, drag_margin)
	set_drag_margin(SIDE_BOTTOM, drag_margin)
	set_drag_margin(SIDE_LEFT, drag_margin)
	set_drag_margin(SIDE_RIGHT, drag_margin)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass

func _process(delta: float) -> void:
	#top_ribbon.position = position
	pass
