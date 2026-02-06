extends CharacterBody2D

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	pass

func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.play("default")
	pass # Replace with function body.
