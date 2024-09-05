extends CanvasLayer

signal volume_changed(value:float)

@onready var root_game = get_node("/root/Game")

func _ready():
	var screen_size = get_viewport().size
	var reference_size = Vector2(1080, 1920)
	
	#var x_scale = 1.0
	#var y_scale = 1.0
	var x_scale = screen_size.x / reference_size.x
	var y_scale = screen_size.y / reference_size.y
#
	#self.set_scale(Vector2(x_scale, y_scale))
	get_viewport().get_canvas_transform().scaled(Vector2(x_scale, y_scale))
	
	
	%VolumeSlider.value = root_game.sound_volume

func _on_replay_pressed() -> void:
	self.visible = false
	
	
	if root_game.has_method("restart_game"):
		root_game.restart_game()


func _on_close_menu_pressed() -> void:
	self.visible = false


	if root_game.has_method("pause_game"):
		root_game.pause_game(false)


func _on_volume_slider_value_changed(value: float) -> void:
	if value != root_game.sound_volume:
		volume_changed.emit(value)


func _on_visibility_changed() -> void:
	if self.visible:
		%VolumeSlider.value = root_game.sound_volume
