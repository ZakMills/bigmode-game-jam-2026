extends Node2D

var item_scene = load("res://ScenesScripts/map_details/logic/item.tscn")
#var test_item_pos = Vector2(195.0, -175.0)
var item_gone : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print($ocean.visible)
	#add_item(Stages.items_starting[Global.day])
	pass # Replace with function body.
	
#func delete_self():
	#$cliff.queue_free()
	#$ocean.queue_free()
	#queue_free()
	

func start():
	#add_item(Vector2(367, -142.0))
	pass
	
func add_item(pos : Vector2):
	var new_item = item_scene.instantiate()
	new_item.position = pos
	new_item.start("feesh")
	self.add_child(new_item)
	#print(new_item.name)
	item_gone = false
	
func clear_items():
	get_tree().call_group("Items", "queue_free")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("carrying? ", Global.carrying_item)
	if (Global.carrying_item == true):
		item_gone = true
		#print("picked up, item is now gone")
	pass
	
func get_item_pos() -> Vector2:
	#print("get item gone ", item_gone)
	if (!item_gone):
		return Vector2(195.0, -175.0)
	else:
		return Vector2.ZERO
