extends Node2D

const CRIT_COLOR = Color(1, 0.718, 0.188)


func set_damage_data(damge:float, crit:bool = false):
	$Label.text = str(damge)
	if crit:
		$Label.set("theme_override_colors/font_color",CRIT_COLOR)
		$Label.add_theme_font_size_override("font_size", 90)
 

func _on_destroy_timeout() -> void:
	queue_free()
