extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_LENGTH = 0.2
const DASH_MULTI = 2

@onready var dash_timer = $DashTimer
@onready var drop_check = $DropCheck
@onready var drop_timer = $DropTimer
@onready var slide_cooldown = $SlideCooldown

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_wall_hanging = false
var has_double_jump = false
var is_dashing = false
var has_dash = false
var has_slide = true
var platform

func _physics_process(delta):

	# Do not allow other movement while dashing
	if is_dashing:
		move_and_slide()
		return
	
	# Reset character to start of level
	if Input.is_action_just_pressed("reset"):
		position = Vector2(64,432)
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		has_double_jump = true
		has_dash = true
		
	if is_wall_hanging and is_on_wall():
		velocity.y *= 0.8
		has_double_jump = true		


	# Get the input direction and handle the movement/deceleration.
	# Accel/decel handled in appropriate functions now
	
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, SPEED * direction, accel())
	else:
		velocity.x = move_toward(velocity.x, 0, decel())
		
	# Handle special movement.
	if Input.is_action_just_pressed("jump"):
		try_jump()
		
	if Input.is_action_just_pressed("dash"):
		try_dash()
	
	if Input.is_action_just_pressed("crouch"):
		try_drop()
		
	move_and_slide()

func try_jump():
	if is_on_floor():
		pass
	elif is_wall_hanging and is_on_wall():
	# This was only able to jump off the left wall, now it jumps
	# opposite of which key is held to stick to the wall
	# I think that's the intended behaviour
		velocity.x = 500 * -Input.get_axis("left", "right")
	elif has_double_jump:
		has_double_jump = false
	else:
		return
	velocity.y = JUMP_VELOCITY

func try_dash():
	if has_slide and is_on_floor():
	# This makes dashes very inconsistent as it's based off current speed
	# Might be desired behaviour, idk, I don't play platformers
		velocity.x *= DASH_MULTI
		scale.x = 0.3
		scale.y = 0.15
		slide_cooldown.start()
		has_slide = false
	elif has_dash and not is_on_floor():
		velocity.x *= DASH_MULTI
		is_dashing = true
		has_dash = false
	else:
		return
	dash_timer.wait_time = DASH_LENGTH
	dash_timer.start()
	velocity.y = 0

func try_drop():
	if drop_check.is_colliding():
		platform = drop_check.get_collider().get_node("CollisionShape2D")
		platform.disabled = true
		drop_timer.start()

func accel() -> float:
	# For dash/slide, effectively behaves as deceleration
	if absf(velocity.x) > SPEED:
		return SPEED / 5
	# For floatier movement when falling / jumping
	elif not is_on_floor() or Input.is_action_just_pressed("jump"):
		return SPEED / 10
	# Mostly for walking, I think
	else:
		return SPEED / 5

func decel() -> float:
	# Deceleration when direction keys are let go
	if absf(velocity.x) > SPEED:
		return SPEED / 5
	elif not is_on_floor() or Input.is_action_just_pressed("jump"):
		return SPEED / 10
	else:
		return SPEED / 5
		
func _on_area_2d_body_entered(body):
	is_wall_hanging = true

func _on_area_2d_body_exited(body):
	is_wall_hanging = false
	
func _on_drop_timer_timeout():
	platform.disabled = false
	
func _on_dash_timer_timeout():
	scale.x = 0.15
	scale.y = 0.3
	is_dashing = false

func _on_slide_cooldown_timeout():
# Make the cooldown obvious to the player somehow, right now it feels weird
	has_slide = true
