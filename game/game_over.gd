extends CanvasLayer

func _ready():
	var screen_size = get_viewport().size
	var reference_size = Vector2(1080, 1920)
	
	var scale_factor = min(screen_size.x / reference_size.x, screen_size.y / reference_size.y)
	
	self.set_scale(Vector2(scale_factor, scale_factor))
