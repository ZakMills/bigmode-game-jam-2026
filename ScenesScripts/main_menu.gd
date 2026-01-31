extends Control

var menu : int = 0 #  0 = main, 1 = instructions, 2 = credits.  Options is in Global
@onready var menus = [$Main, $Instructions, $Credits] # 0 = main, 1 = instructions, 2 = credits.
var active : bool = false
var returned : bool = false # just returned from pause

	
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
	

func start_game():
	active = false
	visible = false
	get_tree().get_root().get_node("Main/MenuManager/MenuBG").visible = false
	get_tree().paused = false
	Global.camera_smoothing()
	Global.mode = 3
	Global.score_reset()
	Global.start_world()
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
	
	
