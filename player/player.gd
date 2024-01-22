extends CharacterBody2D

const SPEED = 200.0
const AIR_SPEED_MULTI = 0.75
const JUMP_VELOCITY = -290.0
const DOUBLE_JUMP_MULTI = 0.95
const DASH_LENGTH = 0.15
const DASH_MULTI = 2.8
const SLIDE_MULTI = 2.3
const SLIDE_JUMP_MULTI = 2.2
const WALL_JUMP_MULTI = 2
const FALL_CLAMP = 400.0
const JUMP_APEX = 5
const JUMP_APEX_MULTI = 0.1
const VAR_JUMP_MULTI = 0.25
const NUDGE_RANGE = 28
const NUDGE_MULTI = 10
const REWIND_DUR = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var wall_hang_direction := 0
var can_wall_hang := false
var is_wall_hanging := false
var is_wall_hanging_left := false
var is_wall_hanging_right := false
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

@onready var dash_timer = $DashTimer
@onready var drop_check = $DropCheck
@onready var coyote_timer = $CoyoteTimer
@onready var wall_hang_timer = $WallHangTimer
@onready var sprite = $AnimatedSprite2D
@onready var double_tap = $DoubleTap
@onready var hitbox = $CollisionShape2D
@onready var jump_buffer = $JumpBuffer
@onready var interact_check = $InteractCheck
@onready var gap_check = $Area2DGapCheck/GapCheck
@onready var area_2d_gap_check = $Area2DGapCheck
@onready var jump_sound = $JumpSound
@onready var effects = $Effects
@onready var long_press = $LongPress

func _physics_process(delta):
	# Do not allow other movement while dashing
	if is_dashing:
		move_and_slide()
		return

	_state_checks()

	_special_actions()

	_special_movement()

	_horizontal_movement()

	_apply_gravity(delta)

	_climbing()

	_animation()

	# Coyote timer has to execute before and after move_and_slide, maybe put in a wrapper?
	if is_on_floor():
		was_on_floor = true

	move_and_slide()

	if was_on_floor and not is_on_floor():
		was_on_floor = false
		coyote_timer.start()


func _state_checks():
	can_wall_hang = is_wall_hanging_left != is_wall_hanging_right
	if is_on_floor():
		has_double_jump = true
		has_dash = true
		is_jumping = false
		is_double_jumping = false
	elif is_on_wall() and can_wall_hang and not is_wall_hanging:
		wall_hang_direction = 1 if is_wall_hanging_right else -1
		is_wall_hanging = true
		wall_hang_timer.start()

	if is_wall_hanging:
		if not is_on_wall() or is_on_floor():
			has_checkpoint = true
			is_wall_hanging = false
			wall_hang_timer.stop()
		else:
			velocity.y *= 0.8
	
	if is_crouching:	
		hitbox.shape.size = Vector2(32,32)
		hitbox.position = Vector2(0,9)
	elif is_sliding:	
		hitbox.shape.size = Vector2(32,22)
		hitbox.position = Vector2(0,14)
	else:
		hitbox.shape.size = Vector2(32,44)
		hitbox.position = Vector2(0,3)


func _special_actions():
	_long_press("reset", try_recall)

	if Input.is_action_just_pressed("interact"):
		_try_interact()
		_try_place_checkpoint()


func _special_movement():
	if Input.is_action_just_pressed("dash"):
		_try_dash_and_slide()

	if Input.is_action_just_pressed("jump"):
		jump_buffer.start()
	if not jump_buffer.is_stopped():
		_try_jump()

	if Input.is_action_just_pressed("crouch"):
		if double_tap.is_stopped():
			double_tap.start()
		else:
			double_tap.stop()
			_try_drop()

	if Input.is_action_pressed("crouch"):
		_try_crouch()
	elif Input.is_action_just_released("crouch"):
		_stop_crouch()

	# Variable jump
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		if is_jumping:
			velocity.y -= velocity.y * VAR_JUMP_MULTI


func _horizontal_movement():
	# Establish baseline horizontal movement
	if wall_hang_timer.is_stopped():
		if is_on_floor():
			motion = Input.get_axis("left", "right") * SPEED
		else:
			motion = Input.get_axis("left", "right") * SPEED * AIR_SPEED_MULTI
	else:
		motion = 0

	# Apply acceleration
	if motion:
		velocity.x = move_toward(velocity.x, motion, _accel())
	else:
		velocity.x = move_toward(velocity.x, 0, _decel())


func _apply_gravity(delta):
	if (is_jumping or is_double_jumping) and absf(velocity.y) < JUMP_APEX and not is_wall_hanging:
		velocity.y += gravity * delta * JUMP_APEX_MULTI
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += gravity * delta * 1.2
		else:
			velocity.y += gravity * delta

	if velocity.y > FALL_CLAMP:
		velocity.y = FALL_CLAMP


func _climbing():
	if is_climbing:
		position.x = lock_x
		velocity.y = Input.get_axis("up", "down") * SPEED


func _try_crouch():
	is_crouching = true


func _stop_crouch():
	is_crouching = false


func _try_jump():
	if Input.is_action_pressed("crouch"):
		_try_drop()
	elif (is_on_floor() or not coyote_timer.is_stopped()) and not jump_buffer.is_stopped():
		if is_sliding:
			_stop_slide()
			velocity.x = motion * SLIDE_JUMP_MULTI
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	elif is_wall_hanging:
		# Apply a jump opposite of the wall hang
		velocity.x = SPEED * WALL_JUMP_MULTI * -wall_hang_direction
		velocity.y = JUMP_VELOCITY * 1
		is_jumping = true
	elif has_double_jump and not is_climbing:
		if is_sliding:
			_stop_slide()
		effects.play("double_jump")
		has_double_jump = false
		velocity.y = JUMP_VELOCITY * DOUBLE_JUMP_MULTI
		is_double_jumping = true
	else:
		return
	if not is_climbing and is_jumping and not jump_sound.playing:
		jump_sound.play()
	jump_buffer.stop()


func _try_dash_and_slide():
	if not motion:
		return
	if not is_sliding and is_on_floor():
		velocity.x = motion * SLIDE_MULTI
		is_sliding = true
	elif has_dash and not is_on_floor():
		dash_timer.wait_time = DASH_LENGTH
		velocity.x = motion * DASH_MULTI
		is_dashing = true
		has_dash = false
		dash_timer.start()
		velocity.y = 0
	else:
		return


func _stop_slide():
	is_sliding = false


func _try_drop():
	if drop_check.is_colliding():
		position.y += 1


func _accel() -> float:
	# For dash/slide, effectively behaves as deceleration
	var accel
	if is_on_floor():
		if absf(velocity.x) > SPEED:
			if is_sliding:
				accel = SPEED / 20
			accel = SPEED / 10
		# Mostly for walking, I think
		else:
			if is_sliding:
				_stop_slide()
			accel = SPEED / 5
	# For floatier movement when falling / jumping
	else:
		if absf(velocity.x) > SPEED:
			accel = SPEED / 20
		else:
			_stop_slide()
			accel = SPEED / 15
	return accel


func _decel() -> float:
	# Deceleration when direction keys are let go
	var decel
	if is_on_floor():
		if absf(velocity.x) > SPEED:
			decel = SPEED / 5
		else:
			if is_sliding:
				_stop_slide()
			decel = SPEED / 3
	else:
		decel = SPEED / 10
	return decel


func _animation():
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


func _get_animation():
	var animation
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


func _long_press(action: String, method: Callable):
	if Input.is_action_just_pressed(action):
		long_press.start()
	elif Input.is_action_just_released(action) and not long_press.is_stopped():
		long_press.stop()
		method.call()
	elif Input.is_action_pressed(action) and long_press.is_stopped():
		method.call(true)
		Input.action_release(action)


func _try_interact():
	if interact_check.is_colliding():
		interact_check.get_collider().interact()


func _try_place_checkpoint():
	var main = get_node("/root/Main")
	if is_on_floor() and has_checkpoint:
		var checkpoint = get_node_or_null("/root/Main/Checkpoint")
		if checkpoint:
			main.scene_history.clear()
			checkpoint.destroy()
		has_checkpoint = false
		var place_checkpoint = load("res://player/checkpoint.tscn").instantiate()
		main.add_child(place_checkpoint)
		main.scene_history = [main.current_scene]


func try_recall(long_reset = false):
	var checkpoint = get_node_or_null("/root/Main/Checkpoint")
	if long_reset:
		_hard_recall()
	elif checkpoint:
		_soft_recall()
	else:
		_hard_recall()


func _hard_recall():
	get_tree().call_deferred("reload_current_scene")


func _soft_recall():
	var main = get_node("/root/Main")
	var checkpoint = get_node("/root/Main/Checkpoint")
	if main.scene_history.size() > 1:
		var delay = REWIND_DUR / main.scene_history.size()
		main.scene_history.reverse()
		for scene in main.scene_history:
			var rewind_level = load(scene).instantiate()
			main.add_child(rewind_level)
			main.current_level.destroy(delay)
			main.current_level = rewind_level
			main.current_scene = scene
		main.scene_history = [main.current_scene]
	var tween = create_tween()
	collision(0)
	(
		tween
		. tween_property(self, "position", checkpoint.position, REWIND_DUR)
		. set_trans(Tween.TRANS_ELASTIC)
		. set_ease(Tween.EASE_IN_OUT)
	)
	tween.tween_callback(collision)


func collision(state = 1):
	set_deferred("collision_layer", state)


func _on_dash_timer_timeout():
	velocity.x = motion
	is_dashing = false


func _on_area_2d_left_body_entered(_body):
	is_wall_hanging_left = true


func _on_area_2d_left_body_exited(_body):
	is_wall_hanging_left = false


func _on_area_2d_right_body_entered(_body):
	is_wall_hanging_right = true


func _on_area_2d_right_body_exited(_body):
	is_wall_hanging_right = false


func _on_area_2d_collision_check_body_entered(_body):
	gap_check.position = velocity.normalized() * NUDGE_RANGE
	if not area_2d_gap_check.get_overlapping_bodies():
		position += velocity.normalized() * NUDGE_MULTI


func _on_area_2d_climbing_area_entered(area):
	if area.is_in_group("climbing"):
		lock_x = position.x
		is_climbing = true


func _on_area_2d_climbing_area_exited(area):
	if area.is_in_group("climbing"):
		is_climbing = false
