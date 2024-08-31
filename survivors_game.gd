extends Node2D


func _ready() -> void:
	%GameOver.visible = false

	for i in range(10):
		spawn_tree()

func spawn_tree():
	var new_mob = preload("res://pine_tree.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	
func spawn_mob():
	var new_mob = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)


func restart_game():
	get_tree().reload_current_scene()


func _on_timer_timeout() -> void:
	spawn_mob()


func _on_timer_spawn_tree_timeout() -> void:
	for i in range(randi_range(5, 10)):
		spawn_tree()


func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true


func _on_new_game_pressed() -> void:
	%GameOver.visible = false
	get_tree().paused = false

	print('pressed')
	restart_game()
