extends Control

#@onready var screen_size = get_viewport_rect().size
#@onready var camera = get_tree().get_root().get_node("Main").get_node("PC").get_node("Camera2D")
#@onready var camera = get_tree().get_root().get_node("Main").get_node("Camera2D")
# Called when the node enters the scene tree for the first time.
#var destination : Vector2
var weather_on = false
var wind_scene = load("res://ScenesScripts/map_details/wind.tscn")
var wind_rate : float = 0.3
	

func _ready() -> void:
	if Global.test:
		pass
	pass # Replace with function body.


func _process(delta: float) -> void:
	#print($WindLayer/wind.global_position, " ", $WindLayer/wind.position, "  ", global_position)
	#print("timer ",  $TimerWeather.time_left)
	#print($Background.visible, "    ", $Background.color)
	set_direction()
	time_update()
	#print("timer paused = ", $Time_left.is_paused())
	pass

func stop_timers():
	$Time_left.set_paused(true)
	$TimerWeather.set_paused(true)
#func resume_timers():
	#$Time_left.set_paused(false)
	#$TimerWeather.set_paused(true)
	
func score_update():
	$ScoreValue.text = str(Global.score)
	$ItemCount.text = str(Global.items_today) + " / " + str(Stages.items_minimum[Global.day])
	pass

func stage_start(time):
	$Time_left.set_paused(false)
	$Time_left.start(time)
	Global.items_today = 0
	$ItemCount.text = str(Global.items_today) + " / " + str(Stages.items_minimum[Global.day])
	weatherSchedule()

func time_update():
	$TimeLeft.text = str(int($Time_left.time_left))

func get_angle(x, y) -> float:
	var vectest = Vector2(x, -y).normalized()
	var angletest = rad_to_deg(Vector2.ZERO.angle_to_point(vectest))
	if (angletest < 0):
		angletest = 360+angletest
	return angletest
	
func set_direction():
	var pos_player = Global.get_pos_player()
	var pos_destination = Global.get_pos_destination()
	#print(Global.carrying_item, "   ", loc_destination)
	if (Global.carrying_item == false && pos_destination == Vector2.ZERO):
		$dir_arrow.visible = false # should only happen in test map
	else: 
		$dir_arrow.visible = true
		var dir = pos_destination - pos_player
		var ang = get_angle(dir.x, dir.y)
		$dir_arrow.rotation_degrees = 360-ang
	pass
		
func blur_direction():
	#TODO: blur the directional arrow based on distance when in a blizzard
	#$AnimatedSprite2D.blur
	#https://forum.godotengine.org/t/is-there-a-way-to-blur-a-sprite/21001/2
	pass

func cover(setting):
	$Cover.visible = setting

func wind_on(is_windy : bool):
	$WindLayer/wind.visible = is_windy
	#wind_rate = 0.3
	#if(is_windy):
		#$WindTimer.start(wind_rate)
	#else:
		#$WindTimer.stop()
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
	$WindLayer.add_child(new_wind)
	new_wind.position = Vector2(0, randf_range(100, Global.screen_size.y))
	pass

func _on_time_left_timeout() -> void:
	cover(true)
	Global.stage_over()
	pass # Replace with function body.
	
func weatherSchedule(): # schedule is between this and _on_timer_weather_timeout()
	#print("day ", Global.day, " ")
	if Global.day == 0:
		$TimerWeather.start(2) # blizzard
		weather_on = false
	if Global.day == 2:
		$TimerWeather.start(1) # windy
		weather_on = false
	if Global.day == 3:
		$TimerWeather.start(Global.day_length / 3) # will turn blizzard on
		weather_on = false # but it is currently off
	if Global.day == 5:
		$TimerWeather.start(Global.day_length / 6) # will turn wind on
		#$TimerWeather.start(2) # will turn blizzard on
		weather_on = false 
		
	pass


func _on_timer_weather_timeout() -> void:
	if Global.day == 0:
		if !(weather_on): # weather turns on
			$TimerWeather.start(5)
			weather_on = true
			Global.blizzard(true)
		elif weather_on: # weather turns off
			$TimerWeather.start(5)
			weather_on = false
			Global.blizzard(false)
	if Global.day == 2:
		if !(weather_on): # weather turns on
			$TimerWeather.start(Global.day_length / 10)
			weather_on = true
			Global.wind_on(true)
		elif weather_on: # weather turns off
			$TimerWeather.start(4*Global.day_length / 10) # half through the day
			weather_on = false
			Global.wind_on(false)
	if Global.day == 3:
		if !(weather_on): # weather turns on
			$TimerWeather.start(Global.day_length / 3)
			weather_on = true
			Global.blizzard(true)
			await get_tree().create_timer(2).timeout
			Global.oil_visible(true)
		elif weather_on: # weather turns off
			#$TimerWeather.start(Global.day_length / 3)
			weather_on = false
			Global.blizzard(false)
	if Global.day == 5:
		if (!Global.windy): # 
			Global.wind_on(true)
			$TimerWeather.start(Global.day_length / 6) 
		elif !(weather_on): # weather turns on, 2/6 or 1/3 through the day
			$TimerWeather.start(Global.day_length / 3) 
			weather_on = true
			Global.blizzard(true)
		elif weather_on: # weather turns off 2/3 through the day
			#$TimerWeather.start(Global.day_length / 3)
			weather_on = false
			Global.blizzard(false)
			Global.wind_on(false)
			
	pass # Replace with function body.
