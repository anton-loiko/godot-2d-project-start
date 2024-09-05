extends CharacterBody2D

#signal mob_health_depleted


const HEALTH:float = 60.0
const SPEAD:float = 300.0
const CRIT_CHANGE:float = 3.5

const CRIT_COLOR = Color(1, 0.718, 0.188)


@onready var health = HEALTH
@onready var player = get_node("/root/Game/Player")
@onready var score_game = get_node("/root/Game/Player/ScoreInGame")
@onready var score_game_over = get_node("/root/Game/GameOver/VBoxContainer/HBoxContainer/ScoreInGameOver")


func add_score():
	if score_game && score_game.has_method("add_score"):
		score_game.add_score()
		score_game_over.add_score()

func spawn_damage_label(damage:float):
	var new_damage = preload("res://game/enemies/damage/damage.tscn").instantiate()
	%MobFollow.progress_ratio = randf()
	new_damage.global_position = %MobFollow.global_position

	if new_damage.has_method("set_damage_data"):
		new_damage.set_damage_data(damage, damage > (HEALTH / CRIT_CHANGE))
		get_parent().add_child(new_damage)


func _ready() -> void:
	%Slime.play_walk()
	

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEAD
	move_and_slide()
	
	 
func take_damage(damage: float):
	spawn_damage_label(damage)
	health -= damage
	%Slime.play_hurt()
	
	if health <= 0.0 :
		add_score()
		queue_free()
		
		var mob_audio = preload("res://game/enemies/mob_audio.tscn").instantiate()
		var smoke = preload("res://assets/smoke_explosion/smoke_explosion.tscn").instantiate()
		
		smoke.global_position = global_position
		
		get_parent().add_child(mob_audio)
		get_parent().add_child(smoke)
	
		#mob_audio.queue_free()
