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
@onready var weather_ref = $UILayer/Weather
var item_pos : Vector2
var dest_pos : Vector2
var music_2 : bool = false
var music_start_point : float = 195
var music_vol_base : float = 0#-10
var music_vol_current : float = -10
var music_vol_blizzard : float = 0
var music_blizzard_max_adjust : float = 30

var test : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Global.test = test
	BGAdjust = $Background.size/2
	$PC.position = $PCStartPos.position #Vector2.ZERO
	to_main_menu()
	TopRibbonRef.z_index = 2
	TransitionRef.z_index = 3
	reset_audio()
	if (test):
		map_real.queue_free()
		Global.set_map(map_test)
		Global.day = 0
		item_pos = map_test.get_item_pos()#.get_node("Item").position
	else: # !testmap
		map_test.queue_free()
		Global.set_map(map_real)
		Global.day = 1
		#item_pos = Vector2(-2406, 2857)
	pass
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print($Music/BlizzardFadeTimer.is_stopped())
	if (!$Music/BlizzardFadeTimer.is_stopped() && !$Music/BlizzardFadeTimer.paused):
		music_vol_blizzard_fade()
	$Background.position = CamRef.global_position - BGAdjust
	#music_pausing()
	#if ($Music/MusicFadeTimer.time_left != 0):
		#music_loop()
	
func quiet_PC():
	$PC.stop_audio()
func update_options_settings():
	$PC.set_sfx_vol()
	var new_vol = 0 + (Global.volume_sfx-50)/2
	$Music/sfx_itemdeliver.volume_db = new_vol
	$Music/sfx_itemget.volume_db = new_vol
	$Music/sfx_menuback.volume_db = new_vol
	$Music/sfx_menufwd.volume_db = new_vol
func fade_in():
	TransitionRef.fadeIn()
func fade_out():
	#print("main fade_out")
	TransitionRef.visible = true
	TransitionRef.fadeOut()
	$PC.velocity = Vector2.ZERO
func switch_to_eval():
	TransitionRef.visible = true
func switch_to_stage():
	TransitionRef.visible = false
func stage_load():
	#print("stage_load")
	reset_PC_position()
	#music_start()
	if (test): 
		TopRibbonRef.stage_start(999) # TODO: Global.day_length  
		map_test.clear_items()
		#print("stage_load, item starting pos")
		map_test.add_item(Stages.items_starting[0])
		#$Music/MusicTimer.start(5)
		#$Music/StageMusic.volume_db = -10
	else: 
		#print("stage_load real, item starting pos")
		TopRibbonRef.stage_start(Global.day_length)
		map_real.clear_items()
		map_real.add_item()
		map_real.set_dropoff()
		# TODO: add starting item		map_real.add_child(item)
	#TopRibbonRef.score_update()
	#if (Global.day == 0):
	#	pass
	if (Global.day == 4):
		oil_visible(true)
	else:
		oil_visible(false)
	fade_in()
	await get_tree().create_timer(2.1).timeout
	#TopRibbonRef.cover(false)
	pass
	
func add_item():
	if (test):
		#print("add item, custom pos")
		#map_test.add_item(Vector2(367, -142.0))
		map_test.add_item(Stages.items_starting[0])
	else: # real map
		map_real.add_item()
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
		item_pos = map_real.get_item_pos()
	return item_pos
func get_dest_pos() -> Vector2:
	if (test):
		return Vector2(-79, -168)
	else: # !testmap, real map
		return map_real.get_dest_pos()
	return Vector2.ZERO
	
func to_main_menu():
	_on_menu_music_finished()
	to_main_menu_keep_music()
func to_main_menu_keep_music():
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
	$PC.lose_item()
	$PC.stop_sfx()
	# TODO: Reset world state
	camera_smoothing(false)
	#$PC/Camera2D.set_zoom(Vector2.ONE)
	stop_pc_audio()
	TopRibbonRef.stop_timers()
	$Music/BlizzardFadeTimer.start(0.0001)
	music_vol_blizzard_fade()
	reset_audio()
	Global.windy = false
	Global.blizzard_on = false
	$PC.reset_visibility()
	to_main_menu()
	
func reset_PC_position():
	$PC.position = $PCStartPos.position #Vector2.ZERO
	$PC/Camera2D.reset_smoothing()
	
func score_update():
	TopRibbonRef.score_update()
	
func blizzard(blizzard_on):
	Global.blizzard_on = blizzard_on
	$PC.switchVisibility(blizzard_on)
	$Music/BlizzardFadeTimer.start(Global.blizzard_fade_time)
	#$PC.switchVisibility(1)
	pass

func start_world():
	#print("start_world")
	$PC.start()
	$PC.sfx_playing = true
	camera_smoothing(true)
	Global.score_reset()
	Global.blizzard_on = false
	stop_menu_audio()
	if (test):
		TopRibbonRef.stage_start(5)
		#await get_tree().create_timer(1).timeout
		#await get_tree().create_timer(4).timeout
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


	
	
func stage_succ():
	#print("run stage_succ")
	TransitionRef.success()
	TransitionRef.fadeIn()
	
func stage_fail():
	TopRibbonRef.score_update()
	TransitionRef.failure()
	TransitionRef.fadeIn()
func game_win():
	TransitionRef.game_win()
	TransitionRef.fadeIn()
	pass
func attach_item(item : Node):
	$PC.get_item(item)
	#print("item gotten") 
	pass

#region audio
func music_vol():
	music_vol_current = music_vol_base + ((Global.volume_music-50)/2)
	$Music/StageMusic.volume_db = music_vol_current #- music_vol_blizzard
	$Music/StageMusicBlizzard.volume_db = music_vol_current #- (music_blizzard_max_adjust-music_vol_blizzard)
	$Music/MenuMusic.volume_db = music_vol_current
	$Music/Win.volume_db = music_vol_current
	$Music/Lose.volume_db = music_vol_current
	if (($Music/BlizzardFadeTimer.is_stopped())):
		_on_blizzard_fade_timer_timeout()
	pass
	
func music_vol_blizzard_fade(): # 0 to 100, 0 means no adjustment, clear weather
	var transition_prct = (1-($Music/BlizzardFadeTimer.time_left / Global.blizzard_fade_time)) * 100
	if (Global.blizzard_on):
		music_vol_blizzard = transition_prct
	else:
		music_vol_blizzard = 100-transition_prct
	music_vol_blizzard *= (music_blizzard_max_adjust/100) # adjust by 60 decibels
	
	# This is meant to make the coming-in-track 
	if (Global.blizzard_on): 
		$Music/StageMusic.volume_db = music_vol_current - music_vol_blizzard
		$Music/StageMusicBlizzard.volume_db = music_vol_current - ((music_blizzard_max_adjust-music_vol_blizzard)/2)
	else:
		$Music/StageMusic.volume_db = music_vol_current - (music_vol_blizzard/2)
		$Music/StageMusicBlizzard.volume_db = music_vol_current - (music_blizzard_max_adjust-music_vol_blizzard)
	#music_vol()
	
func transition_music_play(victory : bool):
	#print("transition_music_play, ", victory)
	if victory:
		$Music/Win.play(0)
	else:
		$Music/Lose.play(0)
	
func transition_music_stop():
	#print("transition_music_stop")
	$Music/Win.stop()
	$Music/Lose.stop()

func reset_audio():
	music_vol()
	#$Music/StageMusic.volume_db = music_vol_base
	$Music/StageMusic.stop()
	#$Music/StageMusic2.volume_db = -100
	#$Music/StageMusic2.stop()
	#$Music/StageMusicBlizzard.volume_db = -100
	$Music/StageMusicBlizzard.stop()
	#$Music/StageMusicBlizzard2.volume_db = -100
	#$Music/StageMusicBlizzard2.stop()
	#$Music/MusicTimer.stop()
	music_vol_blizzard = 0
	music_2 = false
	music_vol()
	pass

func _on_stage_music_finished() -> void:
	#$Music/StageMusic.stop()
	#$Music/StageMusic.volume_db = -100
	pass
func _on_stage_music_2_finished() -> void:
	#$Music/StageMusic2.stop()
	#$Music/StageMusic2.volume_db = -100
	pass
func _on_stage_music_blizzard_finished() -> void:
	#$Music/StageMusicBlizzard.stop()
	#$Music/StageMusicBlizzard.volume_db = -100
	pass
func _on_stage_music_blizzard_2_finished() -> void:
	#$Music/StageMusicBlizzard2.stop()
	#$Music/StageMusicBlizzard2.volume_db = -100
	pass


func _on_music_timer_timeout() -> void:
	#print("_on_music_timer_timeout, ", music_2)
	$Music/StageMusic.play(0)
	#if (music_2): # 1 is playing
		#$Music/StageMusic2.play(0)
		#$Music/StageMusicBlizzard2.play(0)		
		#music_2 = true
	#else:
		#$Music/StageMusic.play(0)
		#$Music/StageMusicBlizzard.play(0)
		#music_2 = false
	#$Music/MusicTimer.start(200)
	#$Music/MusicFadeTimer.start(5)
	pass # Replace with function body.
	
func music_start():
	$Music/StageMusic.play(0)
	$Music/StageMusic.volume_db = music_vol_current
	$Music/StageMusicBlizzard.play(0)
	$Music/StageMusicBlizzard.volume_db = -100
	#$Music/StageMusicBlizzard2.volume_db = -100
	
	#$Music/MusicTimer.set_paused(true)
	#$Music/MusicFadeTimer.set_paused(true)
	#$Music/StageMusic.set_stream_paused(true)
	#$Music/StageMusicBlizzard.set_stream_paused(true)

#func music_loop():
	#var incoming_vol = -50 + (((5-$Music/MusicFadeTimer.time_left)/10)*100)
	##print("music_loop vol = ", $Music/MusicFadeTimer.time_left, "  ", incoming_vol)
	#if (music_2):
		#if (!Global.blizzard_on):
			#$Music/StageMusic2.volume_db = incoming_vol
		#else:
			#$Music/StageMusicBlizzard2.volume_db = incoming_vol
	#else:
		#if (!Global.blizzard_on):
			#$Music/StageMusic.volume_db = incoming_vol
		#else:
			#$Music/StageMusicBlizzard.volume_db = incoming_vol
	#print($Music/StageMusic.volume_db, "    ", $Music/StageMusic2.volume_db, "    ", music_2)
	##print("music_loop music_2 = ", music_2 , "1 = ", $Music/StageMusic.volume_db, " 2 = ", $Music/StageMusic2.volume_db)
	#pass
	
func sound_effect(which: int):
	# 1 = menu back, 2 = menu forward, 3 = item pickup, 4 = delivery
	if (which == 1):
		$Music/sfx_menuback.play(0)
	if (which == 2):
		$Music/sfx_menufwd.play(0)
	if (which == 3):
		$Music/sfx_itemget.play(0)
	if (which == 4):
		$Music/sfx_itemdeliver.play(0)
	

#func music_pausing():
func stage_music_pausing(is_paused):
	#print ("stage_music_pausing")
	#var paused = false
	#if ($MenuManager/PauseMenu.visible || TransitionRef.is_active() || $PC.is_paused()):
		#paused = true
		#print("pausing music")
		
	$Music/sfx_itemget.set_stream_paused(is_paused)
	$Music/sfx_itemdeliver.set_stream_paused(is_paused)
	
	$Music/MusicTimer.set_paused(is_paused)
	$Music/MusicFadeTimer.set_paused(is_paused)
	$Music/StageMusic.set_stream_paused(is_paused)
	#$Music/StageMusic2.set_stream_paused(paused)
	$Music/StageMusicBlizzard.set_stream_paused(is_paused)
	if !$Music/BlizzardFadeTimer.is_stopped():
		$Music/BlizzardFadeTimer.paused = is_paused
	#$Music/StageMusicBlizzard2.set_stream_paused(paused)
	
	
	

	
#endregion

#region Main Menu audio
func stop_menu_audio():
	$Music/MenuMusic.stop()
	$Music/MenuMusic2.stop()
	#$MenuMusicTimer.stop()
	pass
	
func _on_menu_music_finished() -> void:
	$Music/MenuMusic.play(0)
	pass # Replace with function body.

#func _on_menu_music_2_finished() -> void:
	#$MenuMusic2.stop()
	#pass # Replace with function body.

func _on_menu_music_timer_timeout() -> void:
	if (music_2): # 1 is playing
		$Music/MenuMusic2.play(0)
		music_2 = true
	else:
		$Music/MenuMusic.play(0)
		music_2 = false
	$Music/MenuMusicTimer.start(101)
	pass # Replace with function body.
#endregion

func oil_visible(vis):
	if (!test):
		map_real.oil_visible(vis)

func wind_on(is_windy): # TODO: figure this out.  The graphics don't work if you add_child() to a UI layer object?
	TopRibbonRef.wind_on(is_windy)
	#weather_ref.wind_on(is_windy)

# Debug, ignore
func check_vis():
	mainMenu.check_vis()


func _on_blizzard_fade_timer_timeout() -> void:
	if (Global.blizzard_on):
		$Music/StageMusic.volume_db = - 100
	else:
		$Music/StageMusicBlizzard.volume_db = - 100
