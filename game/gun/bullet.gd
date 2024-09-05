extends Area2D

var travelled_distance = 0

const SPEED = 1000;
const RANGE = 1200;
const DAMAGE = 10;
const CRIT_DAMAGE= 25;



func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta

	if travelled_distance > RANGE:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.name.to_lower().begins_with('mob'):
		queue_free()
		
	if body.has_method("take_damage"):
		var damage = round(randf_range(DAMAGE, CRIT_DAMAGE))
		body.take_damage(damage)
