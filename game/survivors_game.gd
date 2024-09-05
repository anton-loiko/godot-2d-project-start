extends Node2D

const SETTINGS_FILE_PATH = "user://settings.save"
const DEFAULT_SOUND_VOLUME: float = 0.5

@onready var pause_menu = get_node("/root/Game/PauseMenu")
@export var sound_volume: float = DEFAULT_SOUND_VOLUME


var open_pasuse_menu



func save_settings_volume(volume: float):
	var file = FileAccess.open(SETTINGS_FILE_PATH, FileAccess.WRITE)
	file.store_float(volume)
	file.close()


func load_settings_volume() -> float:
	if FileAccess.file_exists(SETTINGS_FILE_PATH):
		var file = FileAccess.open(SETTINGS_FILE_PATH, FileAccess.READ)
		var volume = file.get_float()
		
		file.close()
		return volume
	else:
		return DEFAULT_SOUND_VOLUME 



func linear2db(linear_value: float) -> float:
	if linear_value > 0:
		return 20 * log(linear_value) / log(10)
	else:
		return -80

func play_background_sound():
	%BackgroundSound.play()


func change_volume_background_sound(value:float):
	%BackgroundSound.volume_db = linear2db(value)
	sound_volume = value
	save_settings_volume(value)


func spawn_tree():
	var new_tree = preload("res://game/environment/pine_tree.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_tree.global_position = %PathFollow2D.global_position
	add_child(new_tree)


func spawn_mob():
	var new_mob = preload("res://game/enemies/mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)


func pause_game(paused:bool = true):
	get_tree().paused = paused


func restart_game():
	%GameOver.visible = false
	%ScoreInGame.visible = true
	pause_menu.visible = false
	%Button.visible = true
	
	pause_game(false)
	get_tree().reload_current_scene()


func game_over():
	%GameOver.visible = true
	%ScoreInGame.visible = false
	pause_menu.visible = false
	%Button.visible = false
	pause_game()

# Override

func _ready():
	var x_scale = 1.0
	var y_scale = 1.0
	
	get_viewport().get_canvas_transform().scaled(Vector2(x_scale, y_scale))
	play_background_sound()
	
	var saved_sound_volume = load_settings_volume()
	sound_volume = saved_sound_volume
	
	%BackgroundSound.volume_db = linear2db(saved_sound_volume)
	pause_menu.visible = false
	%GameOver.visible = false
	%ScoreInGame.visible = true
	
	
	for i in range(35):
		spawn_tree()


func _on_timer_timeout() -> void:
	spawn_mob()


func _on_timer_spawn_tree_timeout() -> void:
	#for i in range(randi_range(5, 10)):
		#spawn_tree()
	pass


func _on_player_health_depleted() -> void:
	game_over()


func _on_new_game_pressed() -> void:
	restart_game()


func _on_background_sound_finished() -> void:
	play_background_sound()


func _on_button_pressed() -> void:
	pause_game()
	pause_menu.visible = true


func _on_pause_menu_volume_changed(value: float) -> void:
	change_volume_background_sound(value)


func _on_pause_menu_visibility_changed() -> void:
	%Button.visible = !pause_menu.visible
