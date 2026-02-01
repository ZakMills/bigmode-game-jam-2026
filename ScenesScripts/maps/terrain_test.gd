extends Node2D

var item_scene = load("res://ScenesScripts/map_details/item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print($ocean.visible)
	pass # Replace with function body.
	
#func delete_self():
	#$cliff.queue_free()
	#$ocean.queue_free()
	#queue_free()
	

func start():
	print("terrain start")
	add_item(Vector2(195.0, -175.0))
	add_item(Vector2(367, -142.0))
	pass
	
func add_item(pos : Vector2):
	var new_item = item_scene.instantiate()
	new_item.position = pos
	self.add_child(new_item)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
