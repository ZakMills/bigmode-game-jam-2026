extends Node

var score : int = 0
var score_high : int = 0
var mode : int = 0 # 0 intro cutscene, 1 main, 2 how to play, 3 = game
var options_menu : bool = false # options menu reached from either main or pause.
var volume_music : float = 50.0
var volume_sfx : float = 50.0
@onready var main = get_tree().get_root().get_node("Main")
@onready var main_menu = main.get_node("MenuManager").get_node("MainMenu")
@onready var terrain = main.get_node("TerrainManager").get_node("Terrain")
@onready var sfx_player = main.get_node("sfx_player")
@onready var top_ribbon = main.get_node("UILayer").get_node("TopRibbon")
var carrying_item : bool = false
@onready var test : bool = main.test

func set_map(map):
	terrain = map

func camera_smoothing():
	main.camera_smoothing()


func options_display():
	main.options_display()
	
func item_get():
	#print("Global.item_get")
	#sfx_player.play()
	pass
func item_spawn(): # TODO
	pass
	
func score_update(update):
	score += update
	if (score > score_high):
		score_high = score
	top_ribbon.score_update()
	pass
func score_reset():
	score = 0
	score_update(0)

func start_world():
	terrain.start()
	main.sfx_on()
	pass

func stop_pc_audio():
	main.stop_pc_audio()
	
func reset_PC_position():
	main.reset_PC_position()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
