extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("pause")):
		#Conductor.curtainTest()	# Keeping around in case issue recurs.
		if(get_tree().paused):
			resume()
		else:
			pause()

func pause():
	get_tree().paused = true	
	print("pausing")
	#$PauseMenu.visible = true
	visible = true
func resume():
	get_tree().paused = false	
	print("resuming")
	#$PauseMenu.visible = false
	visible = false
