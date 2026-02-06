extends Node2D

var item_scene = load("res://ScenesScripts/map_details/Logic/item.tscn")
var item_pos : Vector2
var possible_item_pos : Array[Vector2] = [Vector2(-2753.667,2950)] # right below your home, first time
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#full_item_spawn_list()
	#possible_item_pos.append(Vector2(-1902.667, 1866.667)) # for testing
	pass
	
	pass # Replace with function body.
func full_item_spawn_list():
	# SW arm
	possible_item_pos.append(Vector2(2817.334, 2221.333))
	possible_item_pos.append(Vector2(2005.333, 1192.0))
	#possible_item_pos.append(Vector2(102.667, 1382.667)) # right in front of hospital
	possible_item_pos.append(Vector2(102.667, 598.0))
	# W arm
	possible_item_pos.append(Vector2(3974.666, -1158.667))
	possible_item_pos.append(Vector2(2837.333, -878.667))
	possible_item_pos.append(Vector2(1845.333, -569.334))
	# N arm
	possible_item_pos.append(Vector2(-605.333, -2446.667))
	possible_item_pos.append(Vector2(724.001, -1100.0))
	possible_item_pos.append(Vector2(1616.0, -1788.0))
	# E arm
	possible_item_pos.append(Vector2(-4292.0, -1122.667))
	possible_item_pos.append(Vector2(-3354.667, -905.333))
	possible_item_pos.append(Vector2(-2557.333, -992.001))
	possible_item_pos.append(Vector2(-2526.667, 22.667))
	# SE arm
	possible_item_pos.append(Vector2(-1902.667, 1866.667))
	possible_item_pos.append(Vector2(-1493.333, 566.667))
	possible_item_pos.append(Vector2(-476.0, 486.667))


func start():
	#print("terrain start")
	#add_item(Vector2(195.0, -175.0))
	#add_item(Vector2(367, -142.0))
	pass
	
func add_item():
	var new_item = item_scene.instantiate()
	new_item.start("feesh")
	
	$AnimatedSprite2D.add_child(new_item)
	if (Global.test):
		new_item.position = Vector2(195.0, -175.0)
	if (Global.score == 0):
		new_item.position = possible_item_pos[0]
	else:
		new_item.position = get_new_pos()
	new_item.scale /= $AnimatedSprite2D.scale
	item_pos = new_item.global_position
	#print(new_item.position, "  and globally  ", new_item.global_position)
	#print("snowman at ", $AnimatedSprite2D/Decorations/Snowman.position, "  and globally  ", $AnimatedSprite2D/Decorations/Snowman.global_position)
	pass

func get_new_pos() -> Vector2:
	#return Vector2(-2070,2777)
	return possible_item_pos[rng.randi_range(0, possible_item_pos.size()-1)]

func set_dropoff():
	#$AnimatedSprite2D/TerrainLogic/dropoff.position = Stages.dropoff[Global.day]
	$AnimatedSprite2D/TerrainLogic/dropoff.position = Stages.dropoff[Global.day]
	pass
	
func get_item_pos() -> Vector2:
	return item_pos
	pass
	
func get_dest_pos() -> Vector2:
	#print($AnimatedSprite2D/TerrainLogic/dropoff.global_position, "  ", $AnimatedSprite2D/TerrainLogic/dropoff.position)
	return $AnimatedSprite2D/TerrainLogic/dropoff.global_position
	pass
	
func clear_items():
	get_tree().call_group("Items", "queue_free")
	pass

func oil_visible(vis):
	$AnimatedSprite2D/Oil.visible = vis
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
