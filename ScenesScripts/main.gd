extends Node

var testx : float = 1600
var testy : float = 1200
#var initialOffset : Vector2 = Vector2(576, 324)
var BGAdjust
@onready var PCRef = $PC
@onready var CamRef = $PC/Camera2D
@onready var TopRibbonRef = $UILayer/TopRibbon
@onready var TransitionRef = $MenuManager/Transition
@onready var mainMenu = $MenuManager/MainMenu
@onready var map_test = $TerrainManager/Terrain_test
@onready var map_real = $TerrainManager/Terrain
@onready var terrain_manager = $TerrainManager
var item_pos : Vector2

var test : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.test = test
	BGAdjust = $Background.size/2
	$PC.position = $PCStartPos.position #Vector2.ZERO
	to_main_menu()
	TopRibbonRef.z_index = 2
	TransitionRef.z_index = 3
	
	
	if (test):
		map_real.queue_free()
		Global.set_map(map_test)
		Global.day = 0
		item_pos = map_test.get_item_pos()#.get_node("Item").position
	else: # !testmap
		map_test.queue_free()
		Global.set_map(map_real)
		Global.day = 1
		item_pos = Vector2.ZERO
	pass
	
func quiet_PC():
	$PC.stop_audio()
	
func fade_in():
	TransitionRef.fadeIn()
func fade_out():
	#print("main fade_out")
	TransitionRef.visible = true
	TransitionRef.fadeOut()
func switch_to_eval():
	TransitionRef.visible = true
func switch_to_stage():
	TransitionRef.visible = false
func stage_load():
	print("running stage_load")
	reset_PC_position()
	if (test): 
		TopRibbonRef.stage_start(5) # TODO: Global.day_length  
		print("should add item")
		get_tree().call_group("Items", "queue_free")
		map_test.add_item(Stages.items_starting[0])
	else: 
		TopRibbonRef.stage_start(Global.day_length)
		# TODO: add starting item		map_real.add_child(item)
	#TopRibbonRef.score_update()
	#if (Global.day == 0):
	#	pass
	fade_in()
	await get_tree().create_timer(2.1).timeout
	#TopRibbonRef.cover(false)
	pass
	
func eval_success():
	TransitionRef.get_node("ScreenSuccess").visible = true
	TransitionRef.get_node("ScreenFail").visible = false
	pass
func eval_fail():
	TransitionRef.get_node("ScreenSuccess").visible = false
	TransitionRef.get_node("ScreenFail").visible = true
	pass
	
func get_item_pos() -> Vector2:
	if (test):
		item_pos = map_test.get_item_pos()#.get_node("Item").position
	else: # !testmap, real map
		item_pos = Vector2.ZERO
	return item_pos

	
func to_main_menu():
	$PC.sfx_playing = false
	mainMenu.start()
	
func back_to_main_menu():
	Global.mode = 1
	get_tree().paused = false
	$MenuManager/PauseMenu.visible = false
	#$MenuManager/MenuBG.visible = true
	$MenuManager/MainMenu.returned = true
	#$MenuManager/MainMenu.get_node("BG").visible = true
	$PC.position = $PCStartPos.position #Vector2.ZERO
	$PC.give_item()
	# TODO: Reset world state
	camera_smoothing(false)
	#$PC/Camera2D.set_zoom(Vector2.ONE)
	stop_pc_audio()
	to_main_menu()
	
func reset_PC_position():
	$PC.position = $PCStartPos.position #Vector2.ZERO
	$PC/Camera2D.reset_smoothing()
	
func score_update():
	TopRibbonRef.score_update()

func start_world():
	$PC.start()
	$PC.sfx_playing = true
	camera_smoothing(true)
	Global.score_reset()
	if (test):
		TopRibbonRef.stage_start(5)
		#await get_tree().create_timer(1).timeout
		#$PC.switchVisibility(0, 1)
		#await get_tree().create_timer(4).timeout
		#$PC.switchVisibility(0, 0)
		pass
	else:
		TopRibbonRef.stage_start(Global.day_length)
		pass
	TopRibbonRef.cover(false)

func cover(setting)	:
	TopRibbonRef.cover(setting)

func stop_pc_audio():
	$PC.stop_audio()

	
func camera_smoothing(setting):
	$PC/Camera2D.position_smoothing_enabled = setting
	var drag_margin = 5
	if (!setting):
		drag_margin = 0
	
	$PC/Camera2D.set_drag_margin(SIDE_TOP, drag_margin)
	$PC/Camera2D.set_drag_margin(SIDE_BOTTOM, drag_margin)
	$PC/Camera2D.set_drag_margin(SIDE_LEFT, drag_margin)
	$PC/Camera2D.set_drag_margin(SIDE_RIGHT, drag_margin)
	#$PC/Camera2D.set_zoom(Vector2(3, 3))
	
func camera_recenter():
	$PC/Camera2D.position = Vector2.ZERO
	
func options_display():
	Global.options_menu = true
	$MenuManager/OptionsMenu.start()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print($PC.get_node("Camera2D").global_position)
	$Background.position = CamRef.global_position - BGAdjust
	pass
	
func stage_succ():
	#print("run stage_succ")
	TransitionRef.success()
	TransitionRef.fadeIn()
	
func stage_fail():
	TransitionRef.failure()
	TransitionRef.fadeIn()
func game_win():
	pass
func attach_item(item : Node):
	$PC.get_item(item)
	#print("item gotten") 
	pass
