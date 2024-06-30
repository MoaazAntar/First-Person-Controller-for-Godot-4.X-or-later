extends CharacterBody3D

@export var mouse_sensitivity = 0.1
@export var min_pitch = -90.0
@export var max_pitch = 90.0

@export var gravity_multiplier = 1.0
@export var jump_height = 1.1

@export var move_speed = 4.0
@export var sprint_speed_modifier = 1.75
@export var crouch_speed_modifier = 0.25
@export var max_speed_in_air = 7.0
@export var acceleration_on_ground = 10.0
@export var acceleration_in_air = 8.0

@export var crouching_sharpness = 10.0
@export var stand_height = 1.8
@export var stand_head_height = 1.45
@export var crouch_height = 0.9
@export var crouch_head_height = 0.725

@onready var head = $Head
@onready var collision_shape = $CollisionShape3D
@onready var shape = collision_shape.shape as CapsuleShape3D
@onready var head_cast = $HeadCast3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_sprinting = false

var is_crouching = false
var target_character_height = 0.0
var target_head_height = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	set_crouching_state(false, true)
	update_character_height(true)

func _input(event):
	# Handle Character Look
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))

func _physics_process(delta):
	# Handle Character Movement
	var input_dir = Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_just_pressed("crouch"):
		set_crouching_state(!is_crouching, false)
	update_character_height(false)
	
	is_sprinting = Input.is_action_pressed("sprint") and input_dir != Vector2.ZERO
	if is_sprinting:
		is_sprinting = set_crouching_state(false, false)
		
	var speed_modifier
	if is_sprinting:
		speed_modifier = sprint_speed_modifier
	else:
		speed_modifier = 1.0
	
	if is_on_floor():
		var target_vel = direction * move_speed * speed_modifier
		
		if is_crouching: target_vel *= crouch_speed_modifier
		
		velocity = lerp(velocity, target_vel, acceleration_on_ground * delta)
		
		# Handle Character Jumping
		if Input.is_action_just_pressed("jump"):
			if set_crouching_state(false, false):
				velocity = Vector3(velocity.x, 0, velocity.z)
				velocity.y = sqrt(2 * jump_height * gravity * gravity_multiplier)
	else:
		velocity += direction * acceleration_in_air * delta
		
		var max_speed = max_speed_in_air * speed_modifier
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
		velocity.z = clamp(velocity.z, -max_speed, max_speed)
		
		velocity.y -= gravity * gravity_multiplier * delta

	move_and_slide()

func update_character_height(force : bool):
	if force:
		shape.height = target_character_height
		collision_shape.position.y = shape.height / 2.0
		head.position.y = target_head_height
	elif shape.height != target_character_height or head.position.y != target_head_height:
		shape.height = lerp(shape.height, target_character_height, crouching_sharpness * get_process_delta_time())
		collision_shape.position.y = shape.height / 2.0
		head.position.y = lerp(head.position.y, target_head_height, crouching_sharpness * get_process_delta_time())

func set_crouching_state(crouch : bool, ignore_obstacles : bool) -> bool:
	if crouch:
		target_character_height = crouch_height
		target_head_height = crouch_head_height
	else:
		if not ignore_obstacles:
			if head_cast.is_colliding():
				print(head_cast.get_collider(0))
				print(head_cast.get_collider(1))
				return false
		
		target_character_height = stand_height
		target_head_height = stand_head_height
	
	is_crouching = crouch
	return true
