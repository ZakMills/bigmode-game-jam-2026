extends Control

var menu : int = 0 #  0 = main, 1 = instructions, 2 = credits.  Options is in Global
@onready var menus = [$Main, $Instructions, $Credits] # 0 = main, 1 = instructions, 2 = credits.
var active : bool = false
var returned : bool = false # just returned from pause
var music_2 : bool = false

func _ready():
	$MenuMusic.volume_db = -20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (active && !Global.options_menu):
		if (Input.is_action_just_pressed("up")):
			#print("in menu, up, ", menus[menu].name)
			menus[menu].up()
			pass
		if (Input.is_action_just_pressed("down")):
			#print("in menu, down, ", menus[menu].name)
			menus[menu].down()
			pass
		if (Input.is_action_just_pressed("space")) && !returned:
			#print("in menu, space, ", menus[menu].name)
			menus[menu].space()
			pass
		if (Input.is_action_just_released("space") && returned):
			returned = false
			pass

func start():
	active = true
	visible = true
	menu = 0
	Global.mode = 1
	hide_other_menus()
	menus[0].start()
	$MenuMusic.play()
	music_2 = false
	$Timer.start(101)

func start_game():
	active = false
	visible = false
	get_tree().get_root().get_node("Main/MenuManager/MenuBG").visible = false
	get_tree().paused = false
	Global.camera_smoothing(true)
	Global.mode = 3
	Global.score_reset()
	Global.start_world()
	Global.stage_load()
	stop_audio()
	#$TerrainManager/Terrain.start()
	
func menu_switch_main():
	hide_other_menus()
	menu = 0
	$Main.start()
func menu_switch_options():
	hide_other_menus()
	Global.options_menu = 1
	pass
func menu_switch_instructions():
	hide_other_menus()
	menu = 1
	$Instructions.start()
func menu_switch_credits():
	menu = 2
	hide_other_menus()
	$Credits.start()
	
func hide_other_menus():
	for each in menus:
		each.visible = false
	
	
#region audio
func stop_audio():
	$MenuMusic.stop()
	$MenuMusic2.stop()
	$Timer.stop()
	pass
	
func _on_menu_music_finished() -> void:
	$MenuMusic.stop()
	pass # Replace with function body.

func _on_menu_music_2_finished() -> void:
	$MenuMusic.stop()
	pass # Replace with function body.

func _on_timer_timeout() -> void:
	if (music_2): # 1 is playing
		$MenuMusic2.play(0)
		music_2 = true
	else:
		$MenuMusic.play(0)
		music_2 = false
	$Timer.start(101)
	pass # Replace with function body.
#endregion
