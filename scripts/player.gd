extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_VELOCITY = SPEED * 4
const DASH_LENGTH = 0.1

@onready var dash_timer = $DashTimer
@onready var drop_check = $DropCheck
@onready var drop_timer = $DropTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jump = false
var is_dashing = false
var has_dash = false
var speed = SPEED
var platform
var is_wall_hanging = false

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
		get_tree().call_group("platforms", "show")
		
	if is_wall_hanging and is_on_wall():
		velocity.y *= 0.8
		has_double_jump = true

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		try_jump()
		
	if Input.is_action_just_pressed("dash"):
		try_dash()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed / 15)
	
		
	if drop_check.is_colliding():
		if Input.is_action_just_pressed("crouch"):
			platform = drop_check.get_collider().get_node("CollisionShape2D")
			platform.disabled = true
			drop_timer.start()

	move_and_slide()

func try_jump():
	if is_on_floor():
		pass
	elif has_double_jump:
		has_double_jump = false
		velocity.x *= 2.5
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
		gravity = 0
		speed = DASH_VELOCITY
		velocity.y = 0

func _on_dash_timer_timeout():
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	speed = SPEED
	is_dashing = false


func _on_drop_timer_timeout():
	platform.disabled = false # Replace with function body.


func _on_area_2d_body_entered(body):
	is_wall_hanging = true


func _on_area_2d_body_exited(body):
	is_wall_hanging = false
