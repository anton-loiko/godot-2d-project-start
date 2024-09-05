extends CanvasLayer

 
func _ready():
	var screen_size = get_viewport().size
	var reference_size = Vector2(1080, 1920)

	var x_scale = screen_size.x / reference_size.x
	var y_scale = screen_size.y / reference_size.y

	self.set_scale(Vector2(x_scale, y_scale))
