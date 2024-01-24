class_name Player extends CharacterBody2D

const SPEED = 200.0
const CROUCH_SPEED_MULTI = 0.6
const AIR_SPEED_MULTI = 0.75
const JUMP_VELOCITY = -290.0
const DOUBLE_JUMP_MULTI = 0.95
const DASH_MULTI = 2.8
const SLIDE_MULTI = 1.6
const SLIDE_JUMP_MULTI = 1
const WALL_JUMP_MULTI = 2
const FALL_CLAMP = 400.0
const WALL_CLAMP_MULTI = 0.1
const JUMP_APEX = 5
const JUMP_APEX_MULTI = 0.1
const VAR_JUMP_MULTI = 0.25
const NUDGE_RANGE = 28
const NUDGE_MULTI = 10
const REWIND_DUR = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var wall_hang_direction := 0
var is_wall_hanging := false
var is_crouching := false
var is_climbing := false
var is_dashing := false
var is_sliding := false
var is_jumping := false
var is_double_jumping := false
var has_dash := false
var has_double_jump := false
var has_checkpoint := false
var was_on_floor := false
var motion: float
var lock_x: float

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var drop_check: RayCast2D = $DropCheck
@onready var interact_check: RayCast2D = $InteractCheck
@onready var dash_timer: Timer = $DashTimer
@onready var slide_timer: Timer = $SlideTimer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer: Timer = $JumpBuffer
@onready var double_tap: Timer = $DoubleTap
@onready var wall_hang_timer: Timer = $WallHangTimer
@onready var long_press: Timer = $LongPress
@onready var area_2d_gap_check: Area2D = $Area2DGapCheck
@onready var gap_check: CollisionShape2D = $Area2DGapCheck/GapCheck
@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var effects: AnimatedSprite2D = $Effects


func _physics_process(delta) -> void:
	_new_physics(delta)
	
func _new_physics(delta):
	_state_checks()
	_special_actions()
	if not is_dashing:
		if is_on_floor():
			if is_sliding:
				_try_slide_jump()
				_try_slide_move()
			else:
				if is_crouching:
					_try_crouch_move()
					_try_drop()
					_try_stop_crouch()
				else:
					_try_move()
					if not _try_crouch():
						if not _try_jump():
							_try_slide()
					
		else:
			if is_climbing:
				if not _try_climb_jump():
					_try_climb_move()
			elif is_wall_hanging:
				if not _try_wall_jump():
					_try_wall_move()
			elif is_sliding:
				_try_coyote_slide_jump()
			else:
				_try_dash()
				if not _try_coyote_jump():
					_try_double_jump()
				_try_air_move(delta)
	_animation()
	move_and_slide()
	if was_on_floor and not is_on_floor():
		was_on_floor = false
		coyote_timer.start()

func _try_move() -> void:
	var change_rate: float
	motion = Input.get_axis("left", "right") * SPEED
	if absf(velocity.x) > SPEED and motion:
		change_rate = SPEED / 10
	else:
		change_rate = SPEED / 5
	velocity.x = move_toward(velocity.x, motion, change_rate)

func _try_air_move(delta) -> void:
	var change_rate: float
	motion = Input.get_axis("left", "right") * SPEED
	if motion*velocity.x > 0 and absf(velocity.x) > SPEED:
		change_rate = SPEED / 25
	else:
		change_rate = SPEED / 5
	velocity.x = move_toward(velocity.x, motion, change_rate)
	if velocity.y > FALL_CLAMP:
		velocity.y = FALL_CLAMP
	elif velocity.y > 0:
		velocity.y += gravity * delta * 1.2
	else:
		velocity.y += gravity * delta

func _try_crouch_move() -> void:
	var change_rate: float
	motion = Input.get_axis("left", "right") * SPEED * CROUCH_SPEED_MULTI
	change_rate = SPEED / 5
	velocity.x = move_toward(velocity.x, motion, change_rate)

func _try_slide_move() -> void:
	var change_rate: float
	motion = Input.get_axis("left", "right") * SPEED * CROUCH_SPEED_MULTI
	if motion*velocity.x < 0:
		velocity.x = -motion
		is_sliding = false

func _try_climb_move() -> void:
	motion = Input.get_axis("up", "down") * SPEED
	velocity.y = motion

func _try_wall_move() -> void:
	motion = Input.get_axis("left", "right") * SPEED
	if wall_hang_timer.is_stopped() and motion:
		velocity.x = move_toward(velocity.x, motion, SPEED)
		is_wall_hanging = false
	velocity.y = FALL_CLAMP * WALL_CLAMP_MULTI

func _try_jump() -> bool:
	if Input.is_action_just_pressed("jump") or not jump_buffer.is_stopped():
			velocity.y = JUMP_VELOCITY
			is_jumping = true
			return true
	return false

func _try_coyote_jump() -> bool:
	if not coyote_timer.is_stopped():
		if Input.is_action_just_pressed("jump") or not jump_buffer.is_stopped():
				velocity.y = JUMP_VELOCITY
				is_jumping = true
				return true
	return false

func _try_slide_jump() -> bool:
	if Input.is_action_just_pressed("jump"):
		velocity.x *= SLIDE_JUMP_MULTI
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		is_sliding = false
		return true
	return false

func _try_coyote_slide_jump() -> bool:
	if Input.is_action_just_pressed("jump"):
		if not coyote_timer.is_stopped():
			velocity.x *= SLIDE_JUMP_MULTI
			velocity.y = JUMP_VELOCITY
			is_jumping = true
			is_sliding = false
			return true
	return false
	
func _try_wall_jump() -> bool:
	if Input.is_action_just_pressed("jump"):
		velocity.x = SPEED * WALL_JUMP_MULTI * -wall_hang_direction
		velocity.y = JUMP_VELOCITY
		wall_hang_timer.stop()
		is_jumping = true
		is_wall_hanging = false
		return true
	return false

func _try_climb_jump() -> bool:
	if Input.is_action_just_pressed("dedicated_jump"):
		velocity.x = motion * WALL_JUMP_MULTI
		velocity.y = JUMP_VELOCITY
		is_climbing = false
		return true
	return false

func _try_double_jump() -> bool:
	if Input.is_action_just_pressed("jump") and has_double_jump:
		velocity.y = JUMP_VELOCITY
		is_double_jumping = true
		return true
	return false

func _try_crouch() -> bool:
	if Input.is_action_just_pressed("down"):
		is_crouching = true
		return true
	return false

func _try_drop() -> bool:
	if Input.is_action_just_pressed("jump"):
		position.y -= 1
		return true
	return false

func _try_stop_crouch() -> bool:
	if not Input.is_action_pressed("down"):
		is_crouching = false
		return true
	return false
	
func _try_dash() -> bool:
	if Input.is_action_just_pressed("dash"):
		motion = Input.get_axis("left", "right")
		if motion and has_dash:
			velocity.x = motion * DASH_MULTI
			velocity.y = 0
			is_dashing = true
			has_dash = false
			dash_timer.start()
	return false
		
func _try_slide() -> bool:
	if Input.is_action_just_pressed("dash"):
		velocity.x = motion * SLIDE_MULTI
		is_sliding = true
		slide_timer.start()
		return true
	return false

func _try_wall_hang(direction) -> bool:
	if not is_on_floor():
		velocity.x = SPEED * direction
		is_wall_hanging = true
		wall_hang_direction = direction
		has_checkpoint = true
		return true
	return false
		

func _state_checks() -> void:
	if is_on_floor():
		was_on_floor = true
		has_double_jump = true
		has_dash = true
		is_jumping = false
		is_double_jumping = false
		is_wall_hanging = false
			
	if is_crouching:
		hitbox.shape.size = Vector2(32, 32)
		hitbox.position = Vector2(0, 9)
	elif is_sliding:
		hitbox.shape.size = Vector2(32, 22)
		hitbox.position = Vector2(0, 14)
	else:
		hitbox.shape.size = Vector2(32, 44)
		hitbox.position = Vector2(0, 3)

func _special_actions() -> void:
	_long_press("reset", try_recall)

	if Input.is_action_just_pressed("interact"):
		_try_interact()

func _animation() -> void:
	# Sprite direction
	if not is_zero_approx(velocity.x) and not is_climbing:
		if velocity.x > 0.0:
			sprite.flip_h = false
			interact_check.scale.x = 1
		else:
			sprite.flip_h = true
			interact_check.scale.x = -1

	# Current animation
	sprite.play(_get_animation())


func _get_animation() -> String:
	var animation: String
	if is_climbing and not Input.get_axis("up", "down"):
		animation = "climbing_idle"
	elif is_climbing:
		animation = "climbing"
	elif is_sliding:
		animation = "sliding"
	elif is_dashing:
		animation = "dashing"
	elif is_wall_hanging:
		animation = "wall"
	elif is_crouching:
		animation = "crouching"
	elif is_on_floor():
		if absf(velocity.x) > 0.1:
			animation = "running"
		else:
			animation = "idle"
	else:
		if velocity.y > -JUMP_VELOCITY:
			animation = "falling"
		else:
			animation = "jumping"
	return animation


func _long_press(action: String, method: Callable) -> void:
	if Input.is_action_just_pressed(action):
		long_press.start()
	elif Input.is_action_just_released(action) and not long_press.is_stopped():
		long_press.stop()
		method.call()
	elif Input.is_action_pressed(action) and long_press.is_stopped():
		method.call(true)
		Input.action_release(action)


func _double_tap(action: String, method: Callable) -> void:
	if Input.is_action_just_pressed(action):
		if double_tap.is_stopped():
			double_tap.start()
		else:
			double_tap.stop()
			method.call()


func _try_interact() -> void:
	if interact_check.is_colliding():
		interact_check.get_collider().interact()
	else:
		_try_place_checkpoint()


func _try_place_checkpoint() -> void:
	var main := get_node("/root/Main")
	if is_on_floor() and has_checkpoint:
		var checkpoint := get_node_or_null("/root/Main/Checkpoint")
		if checkpoint:
			DataStore.scene_history.clear()
			checkpoint.destroy()
		has_checkpoint = false
		var place_checkpoint: Checkpoint = load("res://player/checkpoint.tscn").instantiate()
		main.add_child(place_checkpoint)
		DataStore.scene_history = [DataStore.current_scene]


func try_recall(long_reset = false) -> void:
	var checkpoint := get_node_or_null("/root/Main/Checkpoint")
	if long_reset:
		_hard_recall()
	elif checkpoint:
		_soft_recall()
	else:
		_hard_recall()


func _hard_recall() -> void:
	get_tree().call_deferred("reload_current_scene")


func _soft_recall() -> void:
	var main := get_node("/root/Main")
	var checkpoint := get_node("/root/Main/Checkpoint")
	if DataStore.scene_history.size() > 1:
		@warning_ignore("integer_division")
		var delay: float = REWIND_DUR / DataStore.scene_history.size()
		DataStore.scene_history.reverse()
		for scene in DataStore.scene_history:
			var rewind_level: Node2D = load(scene).instantiate()
			main.add_child(rewind_level)
			DataStore.current_level.destroy(delay)
			DataStore.current_level = rewind_level
			DataStore.current_scene = scene
		DataStore.scene_history = [DataStore.current_scene]
	var tween := create_tween()
	collision(0)
	(
		tween
		. tween_property(self, "position", checkpoint.position, REWIND_DUR)
		. set_trans(Tween.TRANS_ELASTIC)
		. set_ease(Tween.EASE_IN_OUT)
	)
	tween.tween_callback(collision)


func collision(state = 1) -> void:
	set_deferred("collision_layer", state)


func _on_dash_timer_timeout() -> void:
	velocity.x = motion
	is_dashing = false

func _on_slide_timer_timeout() -> void:
	is_sliding = false


func _on_area_2d_left_body_entered(_body) -> void:
	_try_wall_hang(-1)


func _on_area_2d_right_body_entered(_body) -> void:
	_try_wall_hang(1)


func _on_area_2d_collision_check_body_entered(_body) -> void:
	gap_check.position = velocity.normalized() * NUDGE_RANGE
	if not area_2d_gap_check.get_overlapping_bodies():
		position += velocity.normalized() * NUDGE_MULTI


func _on_area_2d_climbing_area_entered(area) -> void:
	if area.is_in_group("climbing"):
		velocity.x = 0
		is_climbing = true


func _on_area_2d_climbing_area_exited(area) -> void:
	if area.is_in_group("climbing"):
		is_climbing = false
