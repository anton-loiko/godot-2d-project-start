extends Area2D


@onready var can_shoot = false

func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	
	can_shoot = enemies_in_range.size() > 0
	
	if can_shoot:
		var target_enemy = enemies_in_range[0]
		look_at(target_enemy.global_position)


func shoot():
	var new_bullet = preload("res://game/gun/bullet.tscn").instantiate()

	new_bullet.global_position = %ShooingPoint.global_position
	new_bullet.global_rotation = %ShooingPoint.global_rotation
	
	%ShooingPoint.add_child(new_bullet)


func _on_timer_timeout() -> void:
	if can_shoot:
		shoot()
