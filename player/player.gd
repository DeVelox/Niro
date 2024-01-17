extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -300.0
const DASH_LENGTH = 0.2
const DASH_MULTI = 2.5
const SLIDE_MULTI = 2.5
const WALL_JUMP_MULTI = 2

@onready var dash_timer = $DashTimer
@onready var drop_check = $DropCheck
@onready var drop_timer = $DropTimer
@onready var coyote_timer = $CoyoteTimer
@onready var sprite = $AnimatedSprite2D
@onready var double_tap = $DoubleTap
@onready var hitbox = $CollisionShape2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_wall_hanging = false
var is_wall_hanging_left = false
var is_wall_hanging_right = false
var has_double_jump = false
var is_dashing = false
var has_dash = false
var is_sliding = false
var platform
var motion
var was_on_floor = false

func _physics_process(delta):
	is_wall_hanging = is_wall_hanging_left != is_wall_hanging_right
	# Reset character to start of level
	if Input.is_action_just_pressed("reset"):
		reload()
		
	if Input.is_action_just_pressed("dash"):
		try_dash()
	# Do not allow other movement while dashing
	if is_dashing:
		move_and_slide()
		return
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Perform state checks
	if is_on_floor():
		has_double_jump = true
		has_dash = true
	elif is_on_wall() and is_wall_hanging:
		velocity.y *= 0.8

	# Establish baseline horizontal movement
	motion = Input.get_axis("left", "right") * SPEED
	
	# Handle special movement.
	if Input.is_action_just_pressed("jump"):
		try_jump()

	if Input.is_action_just_pressed("crouch"):
		if double_tap.is_stopped():
			double_tap.start()
		else:
			double_tap.stop()
			try_drop()

	# Apply acceleration
	if motion:
		velocity.x = move_toward(velocity.x, motion, accel())
	else:
		velocity.x = move_toward(velocity.x, 0, decel())
		
	# Sprite direction
	if not is_zero_approx(velocity.x):
		if velocity.x > 0.0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true

	# Current animation
	sprite.play(get_animation())

	# Coyote timer
	if is_on_floor():
		was_on_floor = true
	
	move_and_slide()
		
	if was_on_floor and not is_on_floor():
		was_on_floor = false
		coyote_timer.start()

func try_jump():
	if is_on_floor() or not coyote_timer.is_stopped():
		if is_sliding:
			stop_slide()
			velocity.x *= 1.3
		velocity.y = JUMP_VELOCITY
	elif is_wall_hanging:
		# Apply a jump opposite of the wall hang
		var wall_direction = 1 if is_wall_hanging_left else -1
		velocity.x = SPEED * WALL_JUMP_MULTI * wall_direction
		velocity.y = JUMP_VELOCITY * 0.75
	elif has_double_jump:
		has_double_jump = false
		velocity.y = JUMP_VELOCITY
	else:
		return

func try_dash():
	if not is_sliding and is_on_floor():	
		velocity.x = motion * SLIDE_MULTI
		hitbox.position.y = 45
		hitbox.scale.y = 0.3
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


func stop_slide():
	hitbox.position.y = 0
	hitbox.scale.y = 1.0
	is_sliding = false

func try_drop():
	if drop_check.is_colliding():
		platform = drop_check.get_collider().get_node("CollisionShape2D")
		platform.disabled = true
		drop_timer.start()

func accel() -> float:
	# For dash/slide, effectively behaves as deceleration
	if absf(velocity.x) > SPEED:
		print(velocity.x)
		if is_sliding:
			return 15
		return 30
	# For floatier movement when falling / jumping
	elif not is_on_floor() or Input.is_action_just_pressed("jump"):
		return 30
	# Mostly for walking, I think
	else:
		if is_sliding:
			stop_slide()
		return 60

func decel() -> float:
	# Deceleration when direction keys are let go
	if absf(velocity.x) > SPEED:
		return 60
	elif not is_on_floor() or Input.is_action_just_pressed("jump"):
		return 30
	else:
		if is_sliding:
			stop_slide()
		return 90
		
func get_animation():
	if Input.is_action_pressed("crouch") and drop_check.is_colliding():
		return "crouching"
	elif is_sliding:
		return "sliding"
	elif is_on_floor():
		if absf(velocity.x) > 0.1:
			return "running"
		else:
			return "idle"
	elif is_dashing:
		return "dashing"
	elif is_wall_hanging:
		return "wall"
	else:
		if velocity.y > 0.0:
			return "falling"
		else:
			return "jumping"

func reload():
	get_tree().reload_current_scene()

func _on_drop_timer_timeout():
	platform.disabled = false
	
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
