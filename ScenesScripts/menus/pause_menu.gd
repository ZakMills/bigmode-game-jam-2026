extends Control

var cursor : int # 0-3
@onready var cursors = [$CursorResume,$CursorOptions,$CursorQuit,$CursorExit]
@onready var main = get_tree().get_root().get_node("Main")

func _ready():
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("pause") && Global.mode == 3 && Global.pausable): # meaning in the game
		if(get_tree().paused):
			resume()
		else:
			pause()
	
	if (visible):
		if (Input.is_action_just_pressed("up")):
			#print("in menu, up, ", menus[menu].name)
			up()
			pass
		if (Input.is_action_just_pressed("down")):
			#print("in menu, down, ", menus[menu].name)
			down()
			pass
		if (Input.is_action_just_pressed("space")):
			#print("in menu, space, ", menus[menu].name)
			space()
			pass

func up():
	cursors[cursor].visible = false
	if (cursor == 0):
		cursor = cursors.size()-1
	else:
		cursor -= 1
	cursors[cursor].visible = true
func down():
	cursors[cursor].visible = false
	if (cursor == cursors.size()-1):
		cursor = 0
	else:
		cursor += 1
	cursors[cursor].visible = true
func space():
	if (cursor == 0): # Resume
		resume()
	elif (cursor == 1): # Options
		main.options_display()
		pass
	elif (cursor == 2): # quit
		main.back_to_main_menu()
		pass
	elif (cursor == 3): # Exit
		get_tree().quit()
	
	pass

func pause():
	get_tree().paused = true	
	#print("pausing")
	visible = true
	cursor = 0
	for each in cursors:
		each.visible = false
	cursors[cursor].visible = true
	Global.stage_music_pausing(true)
	
func resume():
	get_tree().paused = false	
	#print("resuming")
	visible = false
	Global.stage_music_pausing(false)
