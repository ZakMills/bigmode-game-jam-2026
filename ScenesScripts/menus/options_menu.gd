extends Control

var cursor : int # 0-4: start, instructions, credits, options, exit
@onready var cursors = [$CursorMusic,$CursorSFX,$CursorBack]
@onready var main = get_tree().get_root().get_node("Main")
var freshTimer : bool

func _ready():
	visible = false
	freshTimer = true
	
func start():
	#print("options start ", Global.mode)
	cursor = 0
	Global.options_menu = true
	visible = true
	for each in cursors:
		each.visible = false
	cursors[cursor].visible = true
	if (Global.mode == 1):
		main.get_node("MenuManager").get_node("MainMenu").visible = false
		pass
	elif (Global.mode == 3):
		main.get_node("MenuManager").get_node("PauseMenu").visible = false
		#$MainMenuMask.visible = false
		pass
	$TextMusicVol.text = str(Global.volume_music)
	$TextSFXVol.text = str(Global.volume_sfx)
func stop():
	#print("options top ", Global.mode)
	if (Global.mode == 1):
		main.to_main_menu()
		#main.back_to_main_menu()
		pass
	elif (Global.mode == 3):
		main.get_node("MenuManager").get_node("PauseMenu").visible = true
		#$MainMenuMask.visible = false
		pass
	Global.options_menu = false
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Global.options_menu):
		proceed()
func proceed():
	if (Input.is_action_just_pressed("pause") && Global.mode == 3): # meaning in the game
		#cursor = 2
		#space()
		pass
	if (visible):
		if (Input.is_action_just_pressed("up")):
			up()
			pass
		if (Input.is_action_just_pressed("down")):
			down()
			pass
		if (Input.is_action_pressed("left") && $Timer.time_left == 0):
			set_timer()
			left()
			pass
		if (Input.is_action_pressed("right") && $Timer.time_left == 0):
			set_timer()
			right()
			pass
		if (Input.is_action_just_pressed("space")):
			space()
			pass
		if (Input.is_action_just_released("left") || Input.is_action_just_released("right")):
			freshTimer = true
			pass
			
func set_timer():
	if (freshTimer):
		$Timer.start(0.5)
	else:
		$Timer.start(0.1)
	freshTimer = false
	
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
func left():
	#print("options Left")
	if (cursor == 0):
		Global.volume_music -= 1
		$TextMusicVol.text = str(Global.volume_music)
	if (cursor == 1):
		Global.volume_sfx -= 1
		$TextSFXVol.text = str(Global.volume_sfx)
	pass
func right():
	#print("options Right")
	if (cursor == 0):
		Global.volume_music += 1
		$TextMusicVol.text = str(Global.volume_music)
	if (cursor == 1):
		Global.volume_sfx += 1
		$TextSFXVol.text = str(Global.volume_sfx)
	pass
func space():
	if (cursor == 2): # Resume
		Global.options_menu = false
		stop()
		pass
	
	pass
