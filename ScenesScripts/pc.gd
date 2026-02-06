extends CharacterBody2D

var accelMultiplier : float = 5
var velMax : float = 800.0
var screen_size # Size of the game window.
var speedPercent : float = 0
@onready var main = get_tree().get_root().get_node("Main")
var specialAnimation : bool = false
var sprite_size : Vector2
var groundType : int
var galumphTimer : float = 0 # angle in radians.
var galumphFrequency : float = 1 # seconds for one full galumph
var galumphSpeed : float = 500
var item_scene = load("res://ScenesScripts/map_details/Logic/item.tscn")
var splash_mercy : bool = false
var move_type : String = "galumph" # galumph, slide, splash, or falling
var anim_done : bool = false
var speed_multiplier : float = 50.0
var galumph_adjust : float = 10
var sfx_slide = load("res://Sound/SFX/Main Character/Seal Delivery Ice Slide.wav")
var sfx_bounce = load("res://Sound/SFX/Main Character/Seal Delivery Snow Bounce.wav")
var sfx_playing : bool = false
var blizzard_coming : bool = false # change to true if blizzard coming in, false if going out.
var blizzard_fade_time : float = 2

#region move_and_animate
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start()
	screen_size = get_viewport_rect().size
	sprite_size = $AnimatedSprite2D.sprite_frames.get_frame_texture("gal_northeast", 0).get_size()
	$AudioStreamPlayer2DBounce.stop()
	#$AudioStreamPlayer2DBounce.
	$AudioStreamPlayer2DSlide.stop()
	
func start():
	galumphTimer = 0
	$AnimatedSprite2D.play("gal_south")
	$AnimatedSprite2D.stop()
	visibility_modulate(0)
	blizzard_coming = false
	$ReducedVision.visible = false
	set_sfx_vol()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_sfx_vol():
	var new_vol = -10 + (Global.volume_sfx-50)/2
	$AudioStreamPlayer2DBounce.volume_db = new_vol
	$AudioStreamPlayer2DSlide.volume_db = new_vol
	$AudioStreamPlayer2DSplash.volume_db = new_vol
	
func _process(delta: float) -> void:
	#print(position, "  and globally  ", global_position)
	#print("global mode is ", Global.mode)
	#print("audio timer = ", $AudioStreamPlayer2DBounce.get_playback_position())
	#print("timer2 ", $Timer2.time_left)
	if (Global.mode == 3 && $Timer.time_left == 0):
		proceed(delta)
	if (!$Timer2.is_stopped()):
		if (blizzard_coming):
			visibility_modulate((blizzard_fade_time-$Timer2.time_left)/blizzard_fade_time)
		else: # blizzard going
			visibility_modulate((blizzard_fade_time-(blizzard_fade_time-$Timer2.time_left))/blizzard_fade_time)
		
	
	
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
	
	#if Input.is_action_just_pressed("space"):
		#print($GroundDetector.get_overlapping_bodies().is_empty())
		
	if ($GroundDetector.get_overlapping_bodies().any(_ground_type_cliff)): # cliff
		cliff()
		adjust_galumph(0)
	elif ($GroundDetector.get_overlapping_bodies().any(_ground_type_ocean)):
		if ($SplashMercy.time_left == 0):
			#print("cliff")
			adjust_galumph(0)
			move_type = "splash"
			$AudioStreamPlayer2DSplash.play()
			splash()
			pass
	elif ($GroundDetector.get_overlapping_bodies().any(_ground_type_path)): # sliding path
		#print("slide")
		move_type = "slide"
		adjust_galumph(0)
		sliding(accel, delta)
	#elif ($GroundDetector.get_overlapping_bodies().is_empty()): # neither cliff nor path
	elif (move_type != "falling"):
		#print("galumph")
		move_type = "galumph"
		galumph(accel, delta)
	
	if ($GroundDetector.get_overlapping_bodies().any(_ground_type_NPC)):
		give_item()
		
		
	#print(velocity)
		
	#Animations
	if (!specialAnimation):
		animate_movement(accel)
	
	
	if (move_type == "falling"):
		velocity.x = 0
		velocity.y = 200
	
	#velocity *= speed_multiplier
	if(move_type != 'slide'):
		$AudioStreamPlayer2DSlide.stop()

	if (move_type == "slide"):
		#print("sliding at ", velocity.length())
		if ($AudioStreamPlayer2DSlide.playing == true):
			if(velocity.length() < 700):
				$AudioStreamPlayer2DSlide.volume_db = -60+(velocity.length()/14)
			if(velocity.length() < 5):
				$AudioStreamPlayer2DSlide.stop()
			if($AudioStreamPlayer2DSlide.get_playback_position() > 17):
				$AudioStreamPlayer2DSlide.seek(5.0)
		if($AudioStreamPlayer2DSlide.playing == false && velocity.length() > 5):
			$AudioStreamPlayer2DSlide.play(0)
			$AudioStreamPlayer2DSlide.volume_db = -110
				
		
			
			
	move_and_slide()

func _ground_type_path(body):
	if body.name.contains("sliding_path"):
		return true
	return false

func _ground_type_cliff(body):
	if body.name.contains("cliff"):
		return true
	return false

func _ground_type_ocean(body):
	if body.name.contains("ocean"):
		return true
	return false

func _ground_type_NPC(body):
	if body.name.contains("dropoff"):
		return true
	return false


func sliding(accel, delta):
	accel *= accelMultiplier

	if (accel.length() == 0): # if not moving, slow to a stop.
		velocity -= velocity.normalized() * accelMultiplier * 0.5
	else: 
		velocity += accel

	if velocity.length() > velMax:
		velocity = velocity.normalized() * velMax
	#velocity *= delta
		
func galumph(accel, delta):
	galumphTimer += (3.14/galumphFrequency) * delta
	if galumphTimer > 3.14:
		galumphTimer -= 3.14
	velocity = accel * galumphSpeed * sin(galumphTimer)
	
func cliff():
	move_type = "falling"
	$AnimatedSprite2D.flip_v = true
	stop_audio()
	pass


	

	
func splash():
	
	if (Global.carrying_item):
		lose_item()
		Global.add_item()
	$AnimatedSprite2D.set_speed_scale(3)
	$AnimatedSprite2D.play("splash")
	#print("speed scale 3")
	$Timer.start(2)
	$SplashMercy.start(2.1)
	velocity = Vector2.ZERO
	#$AnimatedSprite2D.set_flip_v(true)
	pass
	
func animate_movement(accel : Vector2):
	var dir = ""
	var prev_anim = $AnimatedSprite2D.animation
	#print($AnimatedSprite2D.animation)
	if (accel.length() > 0):
		if (accel.y > 0):
			dir += "S" # south, down
		elif (accel.y < 0):
			dir += "N" # north, up
		if (accel.x > 0):
			dir += "E" # east, right
		elif (accel.x < 0):
			dir += "W" # west, left
			
		if (accel == Vector2.ZERO):
			$AnimatedSprite2D.stop()
	
		
		if (move_type == "galumph"):
			animate_galumph(dir, prev_anim)
		elif (move_type == "slide"):
			animate_slide(dir, prev_anim)
			pass
		
			
		#$AnimatedSprite2D.play("default")
		#speedPercent = (1+2*(velocity.length() / velMax))/3 # scale from 1/3 speed at start
		#$AnimatedSprite2D.set_speed_scale(speedPercent)
		
	elif(move_type == "galumph" && accel == Vector2.ZERO): 
		$AnimatedSprite2D.set_frame_and_progress(0, 0) # set to first frame existing animation
		$AnimatedSprite2D.stop()
		adjust_galumph(0)
		pass
	#print("accel = ", accel)
	
		
func animate_slide(dir, prev_anim):
	var frame = 0
	var progress = 0.0
	var was_sliding = false
	if (prev_anim.contains("slide_")): 
		frame = $AnimatedSprite2D.frame
		progress = $AnimatedSprite2D.frame_progress		
		was_sliding = true
	#print("sliding ", frame, "  ", progress)
	if (dir == "N"): 
		$AnimatedSprite2D.play("slide_north")
	elif (dir == "NE"): 
		$AnimatedSprite2D.play("slide_northeast")
	elif (dir == "E"): 
		$AnimatedSprite2D.play("slide_east")
	elif (dir == "SE"): 
		$AnimatedSprite2D.play("slide_southeast")
	elif (dir == "S"): 
		$AnimatedSprite2D.play("slide_south")
	elif (dir == "SW"): 
		$AnimatedSprite2D.play("slide_southwest")
	elif (dir == "W"): 
		$AnimatedSprite2D.play("slide_west")
	elif (dir == "NW"): 
		$AnimatedSprite2D.play("slide_northwest")
	
	if (was_sliding):
		$AnimatedSprite2D.set_frame_and_progress(frame, progress)
	if (anim_done):
		$AnimatedSprite2D.set_frame_and_progress(3, 0)
	
func animate_galumph(dir, prev_anim):
	anim_done = false
	var frame = 0
	var progress = 0.0
	if (prev_anim.contains("gal_")): 
		frame = $AnimatedSprite2D.frame
		progress = $AnimatedSprite2D.frame_progress
	
	if (dir == "N"): 
		$AnimatedSprite2D.play("gal_north")
	elif (dir == "NE"): 
		$AnimatedSprite2D.play("gal_northeast")
	elif (dir == "E"): 
		$AnimatedSprite2D.play("gal_east")
	elif (dir == "SE"): 
		$AnimatedSprite2D.play("gal_southeast")
	elif (dir == "S"): 
		$AnimatedSprite2D.play("gal_south")
	elif (dir == "SW"): 
		$AnimatedSprite2D.play("gal_southwest")
	elif (dir == "W"): 
		$AnimatedSprite2D.play("gal_west")
	elif (dir == "NW"): 
		$AnimatedSprite2D.play("gal_northwest")
	
	$AnimatedSprite2D.set_frame_and_progress(frame, progress)
	adjust_galumph(frame)
	#if (prev_anim != $AnimatedSprite2D.animation):
		#print("changing gal direction, ", frame, " ", progress)
	#print("Animating galumph ", frame, "  ", progress)
	
func adjust_galumph(frame):
	if (frame == 0 || frame == 4):
		$AnimatedSprite2D.position.y = $GroundDetector.position.y
	elif (frame == 1 || frame == 3):
		$AnimatedSprite2D.position.y = $GroundDetector.position.y - galumph_adjust
	elif (frame == 2):
		$AnimatedSprite2D.position.y = $GroundDetector.position.y - (2*galumph_adjust)
	#if (frame == 0):
		#galumphTimer = 0
	pass
	

func animate_splash():
	pass
func _on_animated_sprite_2d_animation_finished() -> void:
	if (move_type != "galumph"): # the only one this does not apply to
		anim_done = true
	if (move_type == "splash"):
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.visible = false
		#print("speed scale 1")
		$AnimatedSprite2D.set_speed_scale(1)
		anim_done = false
func _on_timer_timeout() -> void:
	Global.reset_PC_position()
	#print("Timer timeout")
	#$AnimatedSprite2D.set_flip_v(false)
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.flip_v = false
	#if (position.length() > 10):
		#Global.camera_smoothing(false)
		#Global.camera_recenter()
		#await get_tree().process_frame
		#Global.camera_smoothing(true)
	pass # Replace with function body.

#endregion
#func _on_ground_detector_body_entered(body: Node2D) -> void:
	#print("body entered")
	#pass
#region interactions
func get_item(item: Node):
	#item.scale = 
	#print("item scale = ", item.scale)
	#print("scale = ", $AnimatedSprite2D.scale )
	Global.carrying_item = true
	var new_item = item_scene.instantiate()
	#print("item shape = ", Global.get_item_shape())
	new_item.scale /= $AnimatedSprite2D.scale
	new_item.start(Global.get_item_shape())
	
	#print("new item scale = ", new_item.scale)
	$AnimatedSprite2D.call_deferred("add_child", new_item) 
	#new_item.position.x = -(item.sprite_size.x/2)
	#new_item.position.y = -($AnimatedSprite2D.scale.y*(sprite_size.y/2)) - item.sprite_size.y
	if (Global.get_item_shape() == "feesh"):
		new_item.position = Vector2(0, -90*(1/$AnimatedSprite2D.scale.y))
	#print("new item scale = ", new_item.scale)
	#print("get_item")
	#Global.item_get()
	pass

func give_item():
	if (Global.carrying_item):
		#$AnimatedSprite2D.get_node("Item").queue_free()
		lose_item()
		Global.items_today += 1
		Global.score_update(10)
		Global.add_item()

func lose_item():
	get_tree().call_group("Items", "queue_free")
	Global.carrying_item = false
#endregion


func _on_animated_sprite_2d_frame_changed() -> void:
	if (sfx_playing):
		if ($AnimatedSprite2D.animation.contains("gal_") && $AnimatedSprite2D.frame == 1):
			#print("audio timer = ", $AudioStreamPlayer2DBounce.get_playback_position())
			if ($AudioStreamPlayer2DBounce.get_playback_position() > 0.5 || !$AudioStreamPlayer2DBounce.playing):
				#print("restarting bounce SFX ")
				if (move_type != "falling"):
					$AudioStreamPlayer2DBounce.play(0)
		if ($AnimatedSprite2D.animation.contains("slide_") && $AnimatedSprite2D.frame == 1):
			$AudioStreamPlayer2DSlide.play(0)
			$AudioStreamPlayer2DSlide.volume_db = -10
			#$Timer2.start(1)
		if (velocity == Vector2.ZERO):#: && sfx_playing == true:
			$AudioStreamPlayer2DSlide.stop()
		#sfx_playing = true #first loading in

func stop_audio():	
	$AudioStreamPlayer2DBounce.play(0)
	$AudioStreamPlayer2DSlide.play(0)
	$AudioStreamPlayer2DBounce.stop()
	$AudioStreamPlayer2DSlide.stop()
	
func toggle_torch(torch):
	if (torch):
		$ReducedVision/gradient.visible = false # less visibility
		$ReducedVision/gradient2.visible = true
	else:
		$ReducedVision/gradient.visible = true # more visibilty
		$ReducedVision/gradient2.visible = false
	
#func reset_visibility():
	#$ReducedVision/gradient.self_modulate.a = 0
	#$ReducedVision/gradient2.self_modulate.a = 0
	#$ReducedVision/LeftSideBar.self_modulate.a = 0
	#$ReducedVision/RightSideBar.self_modulate.a = 0
	#$ReducedVision/BottomBar.self_modulate.a = 0
	#$ReducedVision/TopBar.self_modulate.a = 0
	#$Timer2.stop()
	
func stop_sfx():
	$AudioStreamPlayer2DBounce.stop()
	$AudioStreamPlayer2DSlide.stop()
	$AudioStreamPlayer2DSplash.stop()
	
	
func switchVisibility(blizzard):
	if (bool(blizzard) != $ReducedVision.visible):
		$Timer2.start(blizzard_fade_time)
		blizzard_coming = blizzard
	#print("switching, ", blizzard_coming, $Timer2.time_left)
		
	if (blizzard):
		$ReducedVision.visible = true
			
	else:
		#$ReducedVision.visible = false
		#$ReducedVision/gradient.visible = false
		#$ReducedVision/gradient2.visible = false
		pass
		
func is_paused():
	return get_tree().paused
	
func visibility_modulate(val):
	#print("modulate  ", $ReducedVision/LeftSideBar.self_modulate.a )
	$ReducedVision/gradient.self_modulate.a = val
	$ReducedVision/gradient2.self_modulate.a = val
	$ReducedVision/LeftSideBar.self_modulate.a = val
	$ReducedVision/RightSideBar.self_modulate.a = val
	$ReducedVision/BottomBar.self_modulate.a = val
	$ReducedVision/TopBar.self_modulate.a = val
	#if (val == 0):
		#$Timer2.start(.05)
	pass


func _on_timer_2_timeout() -> void:
	if (!blizzard_coming):
		$ReducedVision.visible = false
	pass
