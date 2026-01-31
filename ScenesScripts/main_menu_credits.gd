extends Control

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass	
	
func start():
	visible = true

func up():
	pass
func down():
	pass
func space():
	#print("credits space")
	parent.menu_switch_main()	
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
