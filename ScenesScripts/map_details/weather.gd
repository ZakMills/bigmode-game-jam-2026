extends Control

var blizzard : bool = false
var windy : bool = false
var weather_on = false
var wind_scene = load("res://ScenesScripts/map_details/wind.tscn")
var wind_rate : float = 0.3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func wind_on(is_windy : bool): # currently uncalled
	wind_rate = 0.3
	if(is_windy):
		$WindTimer.start(wind_rate)
	else:
		$WindTimer.stop()
	pass

func _on_wind_timer_timeout() -> void:
	$WindTimer.start(wind_rate)
	make_wind()
	pass # Replace with function body.
		
func make_wind():
	#print("")
	var new_wind = wind_scene.instantiate()
	var new_scale = randf_range(0.05, 0.2)
	new_wind.scale = Vector2(new_scale, new_scale)
	new_wind.start(randf_range(300, 1000))
	add_child(new_wind)
	new_wind.position = Vector2(0, randf_range(100, Global.screen_size.y))
	pass
