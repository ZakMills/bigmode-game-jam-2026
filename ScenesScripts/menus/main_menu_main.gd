extends Control

var cursor : int # 0-4: start, instructions, credits, options, exit
@onready var cursors = [$CursorStart,$CursorInstructions,$CursorOptions,$CursorCredits,$CursorExit]
@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print("main menu main _ready")
	pass
	
	
func start():
	for each in cursors:
		each.visible = false
	cursor = 0 # starting val
	cursors[cursor].visible = true
	visible = true
	if (Global.score_high != 0):
		$Score.visible = true
		$Score/Score2.text = str(int(Global.score_high))
	else:
		$Score.visible = false

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
	if (cursor == 0): # Start Game
		parent.start_game()
	elif (cursor == 1): # instructions
		parent.menu_switch_instructions()
	elif (cursor == 2): # options
		Global.sound_effect(2)
		parent.visible = false
		Global.options_display()
		pass
	elif (cursor == 3): # credits
		parent.menu_switch_credits()
		pass
	elif (cursor == 4): # exit
		get_tree().quit()
	
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
