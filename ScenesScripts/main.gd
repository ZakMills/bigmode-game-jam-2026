extends Node

var testx : float = 1600
var testy : float = 1200
var initialOffset : Vector2 = Vector2(576, 324)
var BGAdjust
@onready var CamRef = $PC.get_node("Camera2D")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$PC.position = $PCStartPos.position
	#print($TerrainManager.position)
	#$TerrainManager.position = initialOffset
	BGAdjust = $Background.size/2
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print($PC.get_node("Camera2D").global_position)
	$Background.position = CamRef.global_position - BGAdjust
	pass

func attach_item():
	print("item gotten") 
	pass
