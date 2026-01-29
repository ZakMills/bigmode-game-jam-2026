extends Camera2D

var target_zoom : float = 1.0

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
