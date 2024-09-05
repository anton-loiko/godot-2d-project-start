extends CharacterBody2D

signal health_depleted

const HEALTH_FULL_COLOR = Color(0.388, 0.8, 0.373)                     # 100%
const HEALTH_THREE_QUARTERS_COLOR = Color(0.774, 0.818, 0.366)         # 75%
const HEALTH_HALF_COLOR = Color(1, 0.718, 0.188)                       # 50%
const HEALTH_THIRD_COLOR = Color(0.769, 0.114, 0.239)                  # 33%

const HEALTH_FULL = 100.0                                              # 100%
const HEALTH_THREE_QUARTERS = HEALTH_FULL * 0.75                       # 75%
const HEALTH_HALF = HEALTH_FULL * 0.5                                  # 50%
const HEALTH_THIRD = HEALTH_FULL * (1.0 / 3.0)                         # 33%

const DAMAGE_RATE = 5.0
const SPEED_RATE: float = 600.0


@onready var health = HEALTH_FULL

@export var speed : float = SPEED_RATE
@export var joystick_left : VirtualJoystick
@export var joystick_right : VirtualJoystick

var move_vector := Vector2.ZERO

func update_healt_bar_by_percent(percent):
	var new_stylebox_fill = %ProgressBar.get_theme_stylebox("fill").duplicate()
	var prev_color = new_stylebox_fill.bg_color
 	
	if percent > HEALTH_THREE_QUARTERS - 1 && percent < HEALTH_THREE_QUARTERS:
		new_stylebox_fill.bg_color = HEALTH_THREE_QUARTERS_COLOR
	elif percent > HEALTH_HALF - 1 && percent < HEALTH_HALF:
		new_stylebox_fill.bg_color = HEALTH_HALF_COLOR
	elif percent > HEALTH_THIRD - 1 && percent < HEALTH_THIRD:
		new_stylebox_fill.bg_color = HEALTH_THIRD_COLOR
	
	if !prev_color.is_equal_approx(new_stylebox_fill.bg_color):
		%ProgressBar.add_theme_stylebox_override("fill", new_stylebox_fill)


func move(delta:float):
	## Movement using Input functions:
	move_vector = Vector2.ZERO
	move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = move_vector * speed


	# Rotation:
	if joystick_right and joystick_right.is_pressed:
		rotation = joystick_right.output.angle()

 

func _physics_process(delta: float):
	move(delta)
	move_and_slide()

	if velocity.length() > 0.0:
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
	
	var overapping_mobs = %HurtBox.get_overlapping_bodies()
	
	if overapping_mobs.size() > 0:
		if not %PlayerHurtAudio.playing:
			%PlayerHurtAudio.play(0)
		
		
		health -= DAMAGE_RATE * overapping_mobs.size() * delta
		$ProgressBar.value = health
		update_healt_bar_by_percent(health)

 
	if health <= 0.0:
		%PlayerAudio.play()
		
		health_depleted.emit()
		
		# Remove the stylebox override.
		%ProgressBar.remove_theme_stylebox_override("fill")
