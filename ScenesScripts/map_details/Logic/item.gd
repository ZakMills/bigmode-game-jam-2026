extends Area2D

var sprite_size : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Shape.visible = Global.test
	#if (get_parent().name == "Terrain"):
		#scale = Vector2(0.5, 0.5)
	# sprite_size = $Shape.sprite_frames.get_frame_texture("default", 0).get_size()
	pass

func start(itemType):
	#print("item start, ", itemType )
	$Shape.play(itemType)
	sprite_size = $Shape.sprite_frames.get_frame_texture(itemType, 0).get_size()
	$Shape.stop()
	if (itemType == "feesh"):
		$Shape.scale = Vector2(0.3, 0.3)
	sprite_size *= scale
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#func delete_self():
	#queue_free()


func _on_body_entered(body: Node2D) -> void:
	#body.name # can only be player
	if (Global.carrying_item == false):
		scale = Vector2(2, 2)
		get_tree().get_root().get_node("Main").attach_item(self)
		queue_free()
	pass # Replace with function body.
