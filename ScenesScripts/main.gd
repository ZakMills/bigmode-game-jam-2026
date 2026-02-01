extends Node

var testx : float = 1600
var testy : float = 1200
var initialOffset : Vector2 = Vector2(576, 324)
var BGAdjust
@onready var CamRef = $PC/Camera2D
@onready var mainMenu = $MenuManager/MainMenu
@onready var map_test = $TerrainManager/Terrain_test
@onready var map_real = $TerrainManager/Terrain
@onready var terrain_manager = $TerrainManager
var test : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.test = test
	BGAdjust = $Background.size/2
	$PC.position = $PCStartPos.position #Vector2.ZERO
	
	to_main_menu()
	
	if (test):
		map_real.queue_free()
		Global.set_map(map_test)
	else: # !testmap
		map_test.queue_free()
		Global.set_map(map_real)
	pass
	
func to_main_menu():
	$PC.sfx_playing = false
	mainMenu.start()
	
func back_to_main_menu():
	Global.mode = 1
	get_tree().paused = false
	$MenuManager/PauseMenu.visible = false
	$MenuManager/MenuBG.visible = true
	$MenuManager/MainMenu.returned = true
	$PC.position = $PCStartPos.position #Vector2.ZERO
	$PC.give_item()
	# TODO: Reset world state
	$PC/Camera2D.position_smoothing_enabled = false
	#$PC/Camera2D.set_zoom(Vector2.ONE)
	stop_pc_audio()
	to_main_menu()
	
func reset_PC_position():
	$PC.position = $PCStartPos.position #Vector2.ZERO
	
func sfx_on():
	$PC.sfx_playing = true
	
func stop_pc_audio():
	$PC.stop_audio()

	
func camera_smoothing():
	$PC/Camera2D.position_smoothing_enabled = true
	#$PC/Camera2D.set_zoom(Vector2(3, 3))
	
func options_display():
	Global.options_menu = true
	$MenuManager/OptionsMenu.start()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print($PC.get_node("Camera2D").global_position)
	$Background.position = CamRef.global_position - BGAdjust
	pass

func attach_item(item : Node):
	$PC.get_item(item)
	#print("item gotten") 
	pass
