extends Control

func _ready() -> void:
	#$AnimationPlayer.animation_set_next()
	pass

func _process(delta: float) -> void:
	if (get_tree().paused && !$AnimationPlayer.is_playing()):
		if ($ScreenSuccess.visible):
			if Input.is_action_pressed("space"):
				#accel.y -= 1
				Global.stage_next()
				fadeOut()
				pass
			pass # continue only
		if ($ScreenFail.visible):
			if (Input.is_action_just_pressed("up")):
				#print("in menu, up, ", menus[menu].name)
				up()
				pass
			if (Input.is_action_just_pressed("down")):
				#print("in menu, down, ", menus[menu].name)
				down()
				pass
			if (Input.is_action_just_pressed("space")):
				#print("in menu, space, ", menus[menu].name)
				space()
				pass
	pass
	
func up():
	if ($ScreenFail/CursorQuit.visible):
		$ScreenFail/CursorQuit.visible = false
		$ScreenFail/CursorRetry.visible = true
	elif ($ScreenFail/CursorRetry.visible):
		$ScreenFail/CursorQuit.visible = true
		$ScreenFail/CursorRetry.visible = false
func down():
	up() # cheating a bit here
func space():
	if ($ScreenFail/CursorQuit.visible):
		$ScreenFail.visible = false
		Global.back_to_main_menu()
	elif ($ScreenFail/CursorRetry.visible):
		Global.stage_next()
		fadeOut()
	pass
	
func fadeIn() -> void:
	#print("Playing fadeIn")
	#$FadeCurtain.visible = true 
	#$FadeCurtain.fadeIn()
	$Curtain.visible = true
	$AnimationPlayer.play("Fade_in")
	
	# Here to fix a bug
	get_tree().paused = false
	Global.camera_recenter()
	await get_tree().create_timer(0.05).timeout
	get_tree().paused = true
	
func fadeOut() -> void:
	#print("Playing fadeOut")
	#$FadeCurtain.visible = false
	#$FadeCurtain.fadeOut()
	$Curtain.visible = false
	$AnimationPlayer.play("Fade_out")
	await get_tree().create_timer(0.05).timeout
	$Curtain.visible = true
	#$FadeCurtain.visible = true 
	#$AnimationPlayer.play("Fade_out")
	#$Curtain.visible = true
	
func success(): 
	$ScreenSuccess.visible = true
	$ScreenFail.visible = false
func failure(): 
	$ScreenSuccess.visible = false
	$ScreenFail.visible = true
	$ScreenFail/CursorQuit.visible = false
	$ScreenFail/CursorRetry.visible = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("just finished ", anim_name, " transition ", Stages.stage_transition)
	if (anim_name == "Fade_out"):
		if (Stages.stage_transition):
			Global.evaluate()
			Stages.stage_transition = false
		elif (!Stages.stage_transition):#($ScreenSuccess.visible == false && $ScreenFail.visible == false):
			#get_tree().paused = false
			
			Global.stage_load()
			$ScreenSuccess.visible = false
			$ScreenFail.visible = false
	#Conductor.curtainCall(anim_name)
	#print("curtainCall ", anim_name)
	if (anim_name == "Fade_in"):
		if ($ScreenSuccess.visible == false && $ScreenFail.visible == false):
			get_tree().paused = false
			Global.cover(false)
	pass
func _on_animation_player_animation_started(anim_name: StringName) -> void:
	get_tree().paused = true
	pass # Replace with function body.
	
