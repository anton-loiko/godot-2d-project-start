extends Node2D

func _ready():
	%AnimationPlayer.play("animation")
	await $Timer.timeout

	# Add animation or delay if necessary
	get_tree().change_scene_to_file("res://game/survivors_game.tscn")
