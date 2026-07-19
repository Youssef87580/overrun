extends CharacterBody2D

@export var speed : float = 600.0
@export var maximum_jumps := 1
@export var jump_velocity  : float = -500.0
@export var gravity: float = 980.0

func _physics_process(delta: float) -> void: 
	apply_gravity(delta)
	handle_jump()
	handle_horizontal_movement(delta)
	move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta 
	else:
		velocity.y = 0

func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity 
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5

func handle_horizontal_movement(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction  * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta * 10)
