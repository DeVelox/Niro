extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_LENGTH = 0.1
const DASH_MULTI = 4

@onready var dash_timer = $DashTimer
@onready var drop_check = $DropCheck
@onready var drop_timer = $DropTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_wall_hanging = false
var has_double_jump = false
var is_dashing = false
var has_dash = false
var platform
var accel_multi = 1

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
		accel_multi = 0.7
	else:
		accel_multi = 1
		has_double_jump = true
		has_dash = true
		get_tree().call_group("platforms", "show")
		
	if is_wall_hanging and is_on_wall():
		velocity.y *= 0.8
		has_double_jump = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED / 8 * accel_multi )
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED / 5)
		
	# Handle jump.
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
		velocity.x = 500
	elif has_double_jump:
		has_double_jump = false
		#get_tree().call_group("platforms", "hide")
	else:
		return
	velocity.y = JUMP_VELOCITY

func try_dash():
	if has_dash and !is_on_floor():
		is_dashing = true
		has_dash = false
		dash_timer.wait_time = DASH_LENGTH
		dash_timer.start()
		velocity.x *= DASH_MULTI
		velocity.y = 0
		gravity = 0
		
func try_drop():
	if drop_check.is_colliding():
		platform = drop_check.get_collider().get_node("CollisionShape2D")
		platform.disabled = true
		drop_timer.start()
	
func _on_dash_timer_timeout():
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	is_dashing = false 


func _on_drop_timer_timeout():
	platform.disabled = false


func _on_area_2d_body_entered(body):
	is_wall_hanging = true


func _on_area_2d_body_exited(body):
	is_wall_hanging = false
