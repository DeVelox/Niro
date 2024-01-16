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
var double_jump = false
var speed = SPEED
var platform

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		double_jump = true
		get_tree().call_group("platforms", "show")
		
	if is_on_wall():
		velocity.y *= 0.8
		double_jump = true

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		try_jump()
		
	if Input.is_action_just_pressed("dash") and is_on_floor():
		dash_timer.wait_time = DASH_LENGTH
		dash_timer.start()
		gravity = 0
		speed = DASH_VELOCITY

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
	elif double_jump:
		double_jump = false
		velocity.x *= 2.5
		get_tree().call_group("platforms", "hide")
	else:
		return
	velocity.y = JUMP_VELOCITY

func _on_dash_timer_timeout():
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	speed = SPEED


func _on_drop_timer_timeout():
	platform.disabled = false # Replace with function body.
