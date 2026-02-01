extends Area2D

var sprite_size : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_size = $Shape.size
	$Shape.visible = Global.test
	#if (get_parent().name == "Terrain"):
		#scale = Vector2(0.5, 0.5)
	# sprite_size = $Shape.sprite_frames.get_frame_texture("default", 0).get_size()

func start():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	#body.name # can only be player
	if (Global.carrying_item == false):
		scale = Vector2(2, 2)
		get_tree().get_root().get_node("Main").attach_item(self)
		queue_free()
	pass # Replace with function body.
