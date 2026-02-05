extends Control

#@onready var screen_size = get_viewport_rect().size
#@onready var camera = get_tree().get_root().get_node("Main").get_node("PC").get_node("Camera2D")
#@onready var camera = get_tree().get_root().get_node("Main").get_node("Camera2D")
# Called when the node enters the scene tree for the first time.
#var destination : Vector2

func _ready() -> void:
	if Global.test:
		pass
	pass # Replace with function body.


func _process(delta: float) -> void:
	#print($Background.visible, "    ", $Background.color)
	set_direction()
	time_update()
	pass
	
func score_update():
	$ScoreValue.text = str(Global.score)
	$ItemCount.text = str(Global.items_today) + " / " + str(Stages.items_minimum[Global.day])
	pass

func stage_start(time):
	$Time_left.start(time)
	Global.items_today = 0
	$ItemCount.text = str(Global.items_today) + " / " + str(Stages.items_minimum[Global.day])

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

func _on_time_left_timeout() -> void:
	cover(true)
	Global.stage_over()
	pass # Replace with function body.
