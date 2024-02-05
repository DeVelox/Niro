class_name Player extends CharacterBody2D

const SPEED = 170.0
const CROUCH_SPEED_MULTI = 0.6
const AIR_SPEED_MULTI = 0.75
const JUMP_VELOCITY = -290.0
const DOUBLE_JUMP_MULTI = 0.95
const WALL_JUMP_HEIGHT_MULTI = 1.7
const DASH_MULTI = 2.8
const SLIDE_MULTI = 1.8
const SLIDE_JUMP_MULTI = 1.2
const WALL_JUMP_MULTI = 1.7
const FALL_CLAMP = 400.0
const WALL_CLAMP_MULTI = 0.1
const JUMP_APEX = 100
const VAR_JUMP_MULTI = 0.25
const CLIMB_SPEED_MULTI = 0.5
const NUDGE_RANGE = 28
const NUDGE_MULTI = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var wall_hang_direction := 0
var is_wall_hanging := false
var is_crouching := false
var is_climbing := false
var is_climbing_top := 0
var is_climbing_bottom := 0
var is_dashing := false
var is_sliding := false
var is_jumping := false
var is_double_jumping := false
var has_dash := false
var has_double_jump := false
var was_on_floor := false
var can_take_damage := true
var should_take_damage := true

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var dash_timer: Timer = $Timers/DashTimer
@onready var slide_timer: Timer = $Timers/SlideTimer
@onready var slide_cooldown: Timer = $Timers/SlideCooldown
@onready var coyote_timer: Timer = $Timers/CoyoteTimer
@onready var jump_buffer: Timer = $Timers/JumpBuffer
@onready var double_tap: Timer = $Timers/DoubleTap
@onready var wall_hang_timer: Timer = $Timers/WallHangTimer
@onready var long_press: Timer = $Timers/LongPress
@onready var climb_cooldown: Timer = $Timers/ClimbCooldown
@onready var drop_check: RayCast2D = $Detectors/DropCheck
@onready var interact_check: RayCast2D = $Detectors/InteractCheck
@onready var effects: AnimatedSprite2D = $Effects
@onready var invulnerability: Timer = $Timers/Invulnerability
@onready var gap_check: Area2D = $Detectors/GapCheck
@onready var animations: AnimationPlayer = $Animations
@onready var dash_ghost: Timer = $Timers/DashGhost
@onready var repeat_sound: Timer = $Timers/RepeatSound


func _physics_process(delta: float) -> void:
	_state_checks()
	_special_actions()
	_movement(delta)
	_animation()
	_collision_update()
	move_and_slide()
	_coyote()

	_debug_clear()


func _movement(delta: float) -> void:
	if not is_dashing:
		if is_on_floor():
			if is_sliding:
				_try_slide_jump()
				_slide_move()
			else:
				if is_crouching:
					_crouch_move()
					_try_drop()
					_try_stop_crouch()
				else:
					_move()
					if not _try_crouch():
						if not _try_jump():
							_try_slide()

		else:
			if is_climbing:
				if not _try_climb_jump():
					_climb_move()
			elif is_wall_hanging:
				if not _try_wall_jump():
					_wall_move(delta)
			else:
				if not _try_coyote_slide_jump():
					if not _try_coyote_jump():
						if not _try_double_jump():
							_air_move(delta)
							_try_dash()


func _move() -> void:
	var change_rate: float
	var motion: float = Input.get_axis("left", "right") * SPEED
	if absf(velocity.x) > SPEED and motion:
		change_rate = SPEED / 10
	else:
		change_rate = SPEED / 5
	velocity.x = move_toward(velocity.x, motion, change_rate)


func _air_move(delta: float) -> void:
	var change_rate: float
	var motion: float = Input.get_axis("left", "right") * SPEED
	if motion * velocity.x > 0 and absf(velocity.x) > SPEED:
		change_rate = SPEED / 25
	else:
		change_rate = SPEED / 15
	velocity.x = move_toward(velocity.x, motion, change_rate)
	if velocity.y > FALL_CLAMP:
		velocity.y = FALL_CLAMP
	elif velocity.y > 0:
		velocity.y += gravity * delta * 1.2
	else:
		velocity.y += gravity * delta


func _crouch_move() -> void:
	var change_rate: float
	var motion: float = Input.get_axis("left", "right") * SPEED * CROUCH_SPEED_MULTI
	change_rate = SPEED / 5
	velocity.x = move_toward(velocity.x, motion, change_rate)


func _slide_move() -> void:
	var motion: float = Input.get_axis("left", "right") * SPEED * CROUCH_SPEED_MULTI
	if motion * velocity.x < 0:
		velocity.x = -motion
		is_sliding = false


func _climb_move() -> void:
	var motion: float = Input.get_axis("up", "down") * SPEED * CLIMB_SPEED_MULTI
	if is_climbing_top == 0 and motion < 0:
		motion = 0
	velocity.y = motion


func _wall_move(delta) -> void:
	velocity.y += gravity * delta
	if velocity.y > FALL_CLAMP * WALL_CLAMP_MULTI:
		velocity.y = FALL_CLAMP * WALL_CLAMP_MULTI
	return
	#var motion: float = Input.get_axis("left", "right") * SPEED
	#if wall_hang_timer.is_stopped() and motion * wall_hang_direction < 0:
	#velocity.x = move_toward(velocity.x, motion, SPEED)
	#is_wall_hanging = false
	#else:
	#velocity.x = SPEED * wall_hang_direction
	#velocity.y = FALL_CLAMP * WALL_CLAMP_MULTI


func _try_jump() -> bool:
	# Jump buffer not functional
	if Input.is_action_just_pressed("jump") or not jump_buffer.is_stopped():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		Sound.sfx(Sound.JUMP)
		return true
	return false


func _coyote() -> void:
	if was_on_floor and not is_on_floor():
		was_on_floor = false
		coyote_timer.start()


func _try_coyote_jump() -> bool:
	if not coyote_timer.is_stopped():
		_try_jump()
		return true
	return false


func _try_slide_jump() -> bool:
	if Input.is_action_just_pressed("jump") and not gap_check.get_overlapping_bodies():
		velocity.x *= SLIDE_JUMP_MULTI
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		is_sliding = false
		Sound.sfx(Sound.JUMP, 1.1)
		return true
	return false


func _try_coyote_slide_jump() -> bool:
	if not coyote_timer.is_stopped():
		_try_slide_jump()
		return true
	return false


func _try_wall_jump() -> bool:
	if Input.is_action_just_pressed("jump"):
		velocity.x = SPEED * WALL_JUMP_MULTI * -wall_hang_direction
		velocity.y = JUMP_VELOCITY
		wall_hang_timer.stop()
		is_jumping = true
		is_wall_hanging = false
		Sound.sfx(Sound.JUMP, 0.9)
		return true
	return false


func _try_climb_jump() -> bool:
	if Input.is_action_just_pressed("jump"):
		var motion: float = Input.get_axis("left", "right") * SPEED
		velocity.x = motion
		velocity.y = JUMP_VELOCITY
		is_climbing = false
		Sound.sfx(Sound.JUMP, 0.9)
		climb_cooldown.start()
		return true
	return false


func _try_double_jump() -> bool:
	return false
	#if Input.is_action_just_pressed("jump") and has_double_jump:
	#velocity.y = JUMP_VELOCITY
	#has_double_jump = false
	#is_double_jumping = true
	#effects.play("double_jump")
	#Sound.sfx(Sound.DOUBLE_JUMP)
	#return true
	#return false


func _try_crouch() -> bool:
	if Input.is_action_just_pressed("down"):
		is_crouching = true
		Sound.sfx(Sound.CROUCH)
		return true
	return false


func _try_drop() -> bool:
	if Input.is_action_just_pressed("jump"):
		position.y += 5
		return true
	return false


func _try_stop_crouch() -> bool:
	if not Input.is_action_pressed("down") and not gap_check.get_overlapping_bodies():
		is_crouching = false
		return true
	return false


func _try_dash() -> bool:
	if Input.is_action_just_pressed("dash"):
		var motion: float = Input.get_axis("left", "right") * SPEED
		if motion and has_dash:
			velocity.x = motion * DASH_MULTI
			velocity.y = 0
			is_dashing = true
			has_dash = false
			Sound.sfx(Sound.DASH)
			dash_timer.start()
			dash_ghost.start()
		return true
	return false


func _try_slide() -> bool:
	if Input.is_action_just_pressed("dash"):
		var motion: float = Input.get_axis("left", "right") * SPEED
		if motion and slide_cooldown.is_stopped():
			velocity.x = motion * SLIDE_MULTI
			is_sliding = true
			Sound.sfx(Sound.SLIDE)
			slide_timer.start()
		return true
	return false


func _try_wall_hang(direction) -> bool:
	if not is_on_floor():
		is_wall_hanging = true
		wall_hang_direction = direction
		Sound.sfx(Sound.CLIMB_CATCH)
		wall_hang_timer.start()
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

	if is_climbing:
		if is_climbing_bottom + is_climbing_top == 0:
			is_climbing = false


func _collision_update() -> void:
	if is_sliding:
		get_tree().call_group("noclimb", "set", "disabled", true)
		hitbox.shape.radius = 12
		hitbox.shape.height = 16
		hitbox.position = Vector2(0, 26)
	elif is_crouching:
		get_tree().call_group("noclimb", "set", "disabled", true)
		hitbox.shape.radius = 12
		hitbox.shape.height = 28
		hitbox.position = Vector2(0, 20)
	else:
		get_tree().call_group("noclimb", "set", "disabled", false)
		hitbox.shape.radius = 12
		hitbox.shape.height = 48
		hitbox.position = Vector2(0, 10)


func _special_actions() -> void:
	_long_press("reset", _try_recall)

	if Input.is_action_just_pressed("interact"):
		_try_interact()


func _dash_ghost() -> void:
	var ghost: Sprite2D = Sprite2D.new()
	var frame: Texture2D = sprite.get_sprite_frames().get_frame_texture(
		sprite.get_animation(), sprite.get_frame()
	)
	ghost.global_position = global_position
	ghost.texture = frame
	ghost.flip_h = sprite.flip_h
	ghost.scale = sprite.scale
	ghost.modulate = Color(0.5, 1, 1, 0.5)

	#ghost.material = load("res://scripts/shader/shine.tres")

	get_parent().add_child(ghost)

	var tween := create_tween()
	tween.tween_property(ghost, "modulate:a", 0, 0.3)
	#tween.tween_property(ghost.material, "shader_parameter/alpha", 0, 0.5)
	tween.tween_callback(ghost.queue_free)


func _animation() -> void:
	# Sprite direction
	if not is_zero_approx(velocity.x) and not is_climbing:
		if is_wall_hanging:
			if wall_hang_direction > 0.0:
				sprite.flip_h = true
				interact_check.scale.x = -1
			else:
				sprite.flip_h = false
				interact_check.scale.x = 1
		elif velocity.x > 0.0:
			sprite.flip_h = false
			interact_check.scale.x = 1
		else:
			sprite.flip_h = true
			interact_check.scale.x = -1

	# Current animation
	sprite.play(_get_animation())


func _get_animation() -> String:
	var animation: String
	if not is_on_floor():
		if is_climbing and velocity.y == 0:
			animation = "climbing_idle"
		elif is_climbing:
			animation = "climbing"
		elif is_dashing:
			animation = "dashing"
		elif is_wall_hanging:
			animation = "wall"
		else:
			if velocity.y > -JUMP_VELOCITY:
				animation = "falling"
			elif absf(velocity.y) < JUMP_APEX:
				animation = "peak"
			else:
				animation = "jumping"
	else:
		if not was_on_floor:
			animation = "landing"
		elif is_sliding:
			animation = "sliding"
		elif is_crouching and is_zero_approx(velocity.x):
			animation = "crouching_idle"
		elif is_crouching:
			animation = "crouching"
		elif absf(velocity.x) > 0.1:
			animation = "running"
		else:
			animation = "idle"
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


func _try_recall(long_reset = false) -> void:
	var checkpoint := get_node_or_null("/root/Main/Checkpoint")
	if long_reset:
		_hard_recall()
	elif checkpoint and Upgrades.check(Upgrades.Type.RECALL):
		_soft_recall()
	# Don't send the player to the shadow realm on accidental press
	#else:
	#_hard_recall()


func _hard_recall() -> void:
	get_tree().reload_current_scene.call_deferred()


func _soft_recall() -> void:
	var checkpoint := get_node("/root/Main/Checkpoint")
	var rewind_dur: int = Scene.active_tilemap.size() - 1
	var tween := create_tween()

	Scene.recall(rewind_dur)

	_collision(0)
	(
		tween
		. tween_property(self, "position", checkpoint.position, max(1, rewind_dur))
		. set_trans(Tween.TRANS_ELASTIC)
		. set_ease(Tween.EASE_IN_OUT)
	)
	tween.tween_callback(_collision)


func _collision(state = 1) -> void:
	set_deferred("collision_layer", state)


func _absorb() -> void:
	if Upgrades.use_shield():
		Sound.sfx(Sound.SHIELD_HIT)
		invulnerability.start()
		can_take_damage = false
	else:
		_try_recall()


func kill() -> void:
	_try_recall()


func damage() -> void:
	if Upgrades.check(Upgrades.Type.SHIELD):
		_absorb()
	elif can_take_damage:
		_try_recall()


func is_safe() -> void:
	should_take_damage = false


func _on_dash_finished() -> void:
	var motion: float = Input.get_axis("left", "right") * SPEED
	velocity.x = motion
	is_dashing = false
	dash_ghost.stop()


func _on_slide_finished() -> void:
	if gap_check.get_overlapping_bodies():
		is_crouching = true
	slide_cooldown.start()
	is_sliding = false


func _on_left_wall_touched(_body: Node2D) -> void:
	_try_wall_hang(-1)


func _on_right_wall_touched(_body: Node2D) -> void:
	_try_wall_hang(1)


func _on_wall_exited(_body: Node2D) -> void:
	is_wall_hanging = false


func _on_invulnerability_timeout() -> void:
	if should_take_damage:
		_try_recall()
	should_take_damage = true
	can_take_damage = true
	Sound.sfx(Sound.SHIELD_CHARGE)


func camera_shake() -> void:
	animations.play("camera_shake")


func _debug_clear() -> void:
	modulate = Color.WHITE


func debug_color(property: String, invert: bool, color: Color) -> void:
	var state = get(property)
	if invert:
		state = not state
	if state:
		modulate = color


func _start_climbing(body: Node2D) -> void:
	if not is_climbing and climb_cooldown.is_stopped() and not is_on_floor():
		var tile_pos = body.local_to_map(position)
		var pos = body.map_to_local(tile_pos)
		position.x = pos.x
		velocity.x = 0
		is_climbing = true
		is_dashing = false
		Sound.sfx(Sound.CLIMB_CATCH)


func _on_climbing_top_entered(body: Node2D) -> void:
	if is_climbing_top == 0:
		_start_climbing(body)
	is_climbing_top += 1


func _on_climbing_bottom_entered(body: Node2D) -> void:
	if is_climbing_bottom == 0:
		_start_climbing(body)
	is_climbing_bottom += 1


func _on_climbing_top_exited(_body: Node2D) -> void:
	is_climbing_top -= 1


func _on_climbing_bottom_exited(_body: Node2D) -> void:
	is_climbing_bottom -= 1


func _on_screen_exited() -> void:
	if global_position.y < 0:
		return
	_try_recall()


func _on_repeat_sound_timeout() -> void:
	if is_on_floor():
		if is_crouching:
			repeat_sound.wait_time = 0.5
			Sound.sfx(Sound.RUNNING, 0.5)
		elif not is_sliding and not is_zero_approx(velocity.x):
			repeat_sound.wait_time = 0.3
			Sound.sfx(Sound.RUNNING)
	else:
		return
