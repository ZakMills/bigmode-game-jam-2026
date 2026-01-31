extends CharacterBody2D

var accelMultiplier : float = 10
var velMax : float = 800.0
var screen_size # Size of the game window.
var speedPercent : float = 0
@onready var main = get_tree().get_root().get_node("Main")
var specialAnimation : bool = false
var sprite_size : Vector2
var groundType : int
var galumphTimer : float = 0 # angle in radians.
var galumphFrequency : float = 0.5 # seconds for one full galumph
var galumphSpeed : float = 500
var moveType : int # 0 = slide, 1 = galumph
var item_scene = load("res://ScenesScripts/item.tscn")
var carried_item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	sprite_size = $AnimatedSprite2D.sprite_frames.get_frame_texture("movenortheast", 0).get_size()
	galumphTimer = 0
	$AnimatedSprite2D.play("movesouth")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("global mode is ", Global.mode)
	if (Global.mode == 3):
		proceed(delta)
	
func proceed(delta):
	var accel = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("right"):
		accel.x += 1
	if Input.is_action_pressed("left"):
		accel.x -= 1
	if Input.is_action_pressed("down"):
		accel.y += 1
	if Input.is_action_pressed("up"):
		accel.y -= 1
		
	# TODO: weather goes here
	
	if accel.length() > 0:
		accel = accel.normalized()
		
	if Input.is_action_just_pressed("space"):
		print($GroundDetector.get_overlapping_bodies().is_empty())
		
	
	if ($GroundDetector.get_overlapping_bodies().any(_ground_type_cliff)): # cliff
		#print("cliff")
		pass
	elif ($GroundDetector.get_overlapping_bodies().any(_ground_type_path)): # sliding path
		#print("slide")
		slide(accel, delta)
	else: # neither cliff nor path
		galumph(accel, delta)
	
	if ($GroundDetector.get_overlapping_bodies().any(_ground_type_NPC)):
		give_item()
	
	
		
	#Animations
	if (!specialAnimation):
		animate_movement(accel)
	
	
	
	move_and_slide()

func _ground_type_path(body):
	if body.name == "sliding_path":
		return true
	return false

func _ground_type_cliff(body):
	if body.name == "cliff":
		return true
	return false

func _ground_type_NPC(body):
	if body.name == "NPC":
		return true
	return false


func slide(accel, delta):
	accel *= accelMultiplier

	if (accel.length() == 0): # if not moving, slow to a stop.
		velocity -= velocity.normalized() * accelMultiplier * 0.5
	else: 
		velocity += accel

	if velocity.length() > velMax:
		velocity = velocity.normalized() * velMax
		
func galumph(accel, delta):
	galumphTimer += (3.14/galumphFrequency) * delta
	if galumphTimer > 3.14:
		galumphTimer -= 3.14
	velocity = accel * galumphSpeed * sin(galumphTimer)
	
func animate_movement(accel : Vector2):
	var dir = ""
	if (accel.length() > 0):
		if (accel.y > 0):
			dir += "S" # south, down
		elif (accel.y < 0):
			dir += "N" # north, up
		if (accel.x > 0):
			dir += "E" # east, right
		elif (accel.x < 0):
			dir += "W" # west, left
		
		if (dir == "N"): 
			$AnimatedSprite2D.play("movenorth")
		elif (dir == "NE"): 
			$AnimatedSprite2D.play("movenortheast")
		elif (dir == "E"): 
			$AnimatedSprite2D.play("moveeast")
		elif (dir == "SE"): 
			$AnimatedSprite2D.play("movesoutheast")
		elif (dir == "S"): 
			$AnimatedSprite2D.play("movesouth")
		elif (dir == "SW"): 
			$AnimatedSprite2D.play("movesouthwest")
		elif (dir == "W"): 
			$AnimatedSprite2D.play("movewest")
		elif (dir == "NW"): 
			$AnimatedSprite2D.play("movenorthwest")
			
			
		#$AnimatedSprite2D.play("default")
		speedPercent = (1+2*(velocity.length() / velMax))/3 # scale from 1/3 speed at start
		$AnimatedSprite2D.set_speed_scale(speedPercent)
	else: 
		$AnimatedSprite2D.set_frame_and_progress(0, 0) # set to first frame existing animation


#func _on_ground_detector_body_entered(body: Node2D) -> void:
	#print("body entered")
	#pass

func get_item(item: Node):
	print("item size = ", item.sprite_size)
	#item.scale = 
	print("item scale = ", item.scale)
	print("scale = ", $AnimatedSprite2D.scale )
	Global.carrying_item = true
	var new_item = item_scene.instantiate()
	print("new item scale = ", new_item.scale)
	self.call_deferred("add_child", new_item) 
	new_item.position.x = -(item.sprite_size.x/2)
	new_item.position.y = -($AnimatedSprite2D.scale.y*(sprite_size.y/2)) - item.sprite_size.y
	print("new item scale = ", new_item.scale)
	#print("get_item")
	#Global.item_get()
	pass

func give_item():
	#for _i in self.get_children():
		#print(_i)
	
	if (Global.carrying_item):
		get_node("Node2D").queue_free()
		Global.carrying_item = false
		Global.score_update(10)
	pass
