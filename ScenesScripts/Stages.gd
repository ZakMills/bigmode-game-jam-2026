extends Node
# Separated out from Globals for length

var dropoff = [Vector2(-79,-168),Vector2(-2853, 2684.0),Vector2(0,0),Vector2(0,0),Vector2(0,0),Vector2(0,0)]
var items_minimum : Array[int] = [1, 1, 1, 1, 1, 1]
var items_starting = [Vector2(195.0, -175.0),Vector2(0,0),Vector2(0,0),Vector2(0,0),Vector2(0,0),Vector2(0,0)]
@onready var stage_transition : bool = false


# Weather schedule detailed here for planning, implemented in the TopRibbon scene.
# Days summary, in plain english:
# general: days are 3 minutes long.
# 0: Test level.  change main.gd test to true
# 1: Bring X fish to friend.  No special weather.
# 2: Bring X more fish home.  High winds for last 90 seconds
# 3: Blizzard from 0 to 90 seconds.  Oil tanker spill visible afterwards
# 4: Bring X oily birds to a washing station


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func start_day():
	if (Global.day == 0):
		pass
	if (Global.day == 1):
		pass
	if (Global.day == 1):
		pass
	if (Global.day == 1):
		pass
	if (Global.day == 1):
		pass
	if (Global.day == 1):
		pass
	pass
