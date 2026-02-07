extends Node
# Separated out from Globals for length

var dropoff = [Vector2(-79,-168),Vector2(-2853, 2574),Vector2(-1630,2412),Vector2(-2346,-836),Vector2(-42,1138),Vector2(-2853, 2574)]
# Test, seal's home, penguin's home, biggie's home, hospital, seal's home
var items_minimum : Array[int] = [1, 3, 5, 5, 6, 8]
var items_type : Array[String] = ["feesh", "feesh","feesh", "feesh", "oilbird", "shell"]
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
	
#func start_day():
	#if (Global.day == 0):
		#pass
	#if (Global.day == 1):
		#pass
	#if (Global.day == 1):
		#pass
	#if (Global.day == 1):
		#pass
	#if (Global.day == 1):
		#pass
	#if (Global.day == 1):
		#pass
	#pass
