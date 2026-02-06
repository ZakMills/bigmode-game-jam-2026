extends Node2D

var item_scene = load("res://ScenesScripts/map_details/Logic/item.tscn")
var item_pos : Vector2
var possible_item_pos : Array[Vector2] = [Vector2(-2753.667,2950)] # right below your home, first time
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#possible_item_pos.append(Vector2(-2170,2777)) # near your igloo
	# SW arm
	#possible_item_pos.append(Vector2(-1902.667,1866.667))
	# W arm
	#possible_item_pos.append(Vector2())
	# N arm
	#possible_item_pos.append(Vector2())
	# E arm
	#possible_item_pos.append(Vector2())
	# SE arm
	#possible_item_pos.append(Vector2())
	
	pass # Replace with function body.

func start():
	#print("terrain start")
	#add_item(Vector2(195.0, -175.0))
	#add_item(Vector2(367, -142.0))
	pass
	
func add_item(pos : Vector2):
	var new_item = item_scene.instantiate()
	new_item.start("feesh")
	$AnimatedSprite2D.add_child(new_item)
	if (Global.score == 0):
		new_item.position = possible_item_pos[0]
	else:
		new_item.position = get_new_pos()
	item_pos = new_item.global_position
	#print(new_item.position, "  and globally  ", new_item.global_position)
	#print("snowman at ", $AnimatedSprite2D/Decorations/Snowman.position, "  and globally  ", $AnimatedSprite2D/Decorations/Snowman.global_position)
	pass

func get_new_pos() -> Vector2:
	#return Vector2(-2070,2777)
	return possible_item_pos[rng.randi_range(0, possible_item_pos.size()-1)]

func set_dropoff():
	#$AnimatedSprite2D/TerrainLogic/dropoff.position = Stages.dropoff[Global.day]
	$AnimatedSprite2D/TerrainLogic/dropoff.position = Stages.dropoff[1]
	pass
	
func get_item_pos() -> Vector2:
	return item_pos
	pass
	
func get_dest_pos() -> Vector2:
	return $AnimatedSprite2D/TerrainLogic/dropoff.global_position
	pass
	
func clear_items():
	get_tree().call_group("Items", "queue_free")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
