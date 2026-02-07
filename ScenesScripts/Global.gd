extends Node

var screen_size : Vector2
@onready var main = get_tree().get_root().get_node("Main")
@onready var main_menu = main.get_node("MenuManager").get_node("MainMenu")
@onready var terrain = main.get_node("TerrainManager").get_node("Terrain")
#@onready var sfx_player = main.get_node("sfx_player")
@onready var test : bool = main.test
var score : int = 0
var score_saved : int = 0 # saved at the start of the day for retry.
var score_high : int = 0
var mode : int = 0 # 0 intro cutscene, 1 main, 2 how to play, 3 = game
@onready var options_menu : bool = false # options menu reached from either main or pause.
var volume_music : float = 50.0
var volume_sfx : float = 50.0
var blizzard_on : bool = false
var windy : bool = false

var carrying_item : bool = false
var items_today : int = 0
@onready var day : int = 0 # 0 for test, then 1-5.
var day_length : float = 201
var pausable : bool = false
var blizzard_fade_time : float


# Stages.gd contains:
# dropoff[], the dropoff locations for each day
# items_minimum[], the minimum items to pass each day
# the weather schedule

# main.gd contains most methods that involve logic that crosses scenes, after coming through here.

func stage_over():
	pausable = false
	get_tree().paused = true
	Stages.stage_transition = true
	carrying_item = false
	fade_out()
	reset_audio() # TODO: fade_out
	if (items_today >= Stages.items_minimum[day]):
		transition_music_play(true)
	else:
		transition_music_play(false)
	#Global.stage_music_pausing(true)
	#evaluate()
func stage_load():
	main.stage_load()
	pass
func fade_in():
	main.fade_in()
func fade_out():
	main.fade_out()
func evaluate(): # check if player won/lost level
	#print("run evaluate")
	if (!test):
		if (items_today >= Stages.items_minimum[day]):
		#if (items_today >= 1):
			score_update(day * 100)
			day += 1
			if (day >= 1 && day <= 5):
				main.stage_succ()
			elif (day == 6): # game complete				
				day = 1
				main.game_win()
				#else:
			#main.eval_success()
			pass
		else:
			#print("reset score")
			score = score_saved
			main.stage_fail()
			pass
	else:
		if (items_today >= Stages.items_minimum[day]):
			main.stage_succ()
			pass
		else:
			main.stage_fail()
			
	pass
func stage_next():
	#print("stage_next")
	if (!test):
		#day += 1
		score_high_update()
		score_saved = score
	stage_load()
func stage_retry():
	#print("stage_retry")
	score = score_saved
	stage_load()
	pass
func score_update(update):
	score += update
	main.score_update()
	pass
func score_high_update():
	if (score > score_high):
		score_high = score
func score_reset():
	score = 0
	score_update(0)

func get_pos_player() -> Vector2:
	return main.PCRef.position
func get_pos_destination() -> Vector2:
	if (carrying_item): # get dropoff of that day
		return main.get_dest_pos()
	else: # get location of item
		return main.get_item_pos()
		#if (!test):
			#return main.get_item_pos()
		#else: # test map
			#return 
			
	return Vector2.ZERO

func set_map(map):
	terrain = map

func update_options_settings():
	main.update_options_settings()

func back_to_main_menu():
	main.back_to_main_menu()
	

func camera_recenter():
	main.camera_recenter()
	main.quiet_PC()

func camera_smoothing(setting : bool):
	main.camera_smoothing(setting)

func options_display():
	main.options_display()
	
func item_get():
	#print("Global.item_get")
	#sfx_player.play()
	pass
func item_spawn(): # TODO
	pass
	

func start_world():
	terrain.start()
	main.start_world()
	pass

func stop_pc_audio():
	main.stop_pc_audio()
	
func reset_PC_position():
	main.reset_PC_position()

func cover(setting : bool):
	main.cover(setting)
	
func get_item_shape() -> String:
	if day == 0:
		return "feesh"
	elif day == 1:
		return "feesh"
	elif day == 2:
		return "feesh"
	elif day == 3:
		return "feesh"
	elif day == 4:
		return "feesh"
	elif day == 5:
		return "feesh"
	return "feesh"
	
func add_item():
	main.add_item()
	pass
	
func blizzard(on):
	main.blizzard(on)

func music_vol():
	main.music_vol() # volume_music
	
func music_start():
	#print("global, music start")
	main.music_start()
# Called when the node enters the scene tree for the first time.
	
func transition_music_play(victory : bool):
	main.transition_music_play(victory)
func transition_music_stop():
	main.transition_music_stop()

func reset_audio():
	main.reset_audio()

func sound_effect(which: int):
	# 1 = menu back, 2 = menu forward, 3 = item pickup, 4 = delivery
	main.sound_effect(which)

func stage_music_pausing(is_paused):
	main.stage_music_pausing(is_paused)


func _ready() -> void:
	pass # Replace with function body.	
func _process(delta: float) -> void:
	pass
	
func wind_on(is_windy):
	windy = is_windy
	main.wind_on(is_windy)

func check_vis():
	main.check_vis()

func oil_visible(vis):
	main.oil_visible(vis)
