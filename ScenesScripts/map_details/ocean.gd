extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if (get_node_or_null("/ocean/Shape") != null):
		#$Shape.visible = Global.test
	#pass # Replace with function body.
	$Shape.visible = Global.test


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
