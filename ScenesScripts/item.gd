extends Area2D

var sprite_size : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func start():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	#body.name # can only be player
	# get animation name, pass it to main, delete self.
	get_tree().get_root().get_node("Main").attach_item()
	queue_free()
	pass # Replace with function body.
