extends Node2D

var item_scene = load("res://ScenesScripts/item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func start():
	print("terrain start")
	add_item(Vector2(195.0, -125.0))
	add_item(Vector2(367, -92.0))
	pass
	
func add_item(pos : Vector2):
	var new_item = item_scene.instantiate()
	new_item.position = pos
	self.add_child(new_item)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
