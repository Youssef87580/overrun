extends CharacterBody2D

@export var speed : float = 200.0
@export var maximum_jumps := 1
@export var jump_velocity  : float = -250.0
@export var gravity: float = 980.0
@export var coyote_time: float = 0.1
var coyote_timer: float = 0.0 
var gravity_direction: int = 1

func _physics_process(delta: float) -> void: 
	handle_gravity_flip()
	up_direction = Vector2(0, -gravity_direction)
	apply_gravity(delta)
	handle_jump()
	handle_horizontal_movement(delta)
	move_and_slide()

func handle_gravity_flip() -> void:
	if Input.is_action_just_pressed("flip_gravity"):
		gravity_direction *= -1

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * gravity_direction * delta 
	else:
		velocity.y = 0

func handle_jump() -> void:
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer = max(coyote_timer - get_physics_process_delta_time(), 0.0)
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer > 0) :
		velocity.y = jump_velocity * gravity_direction
		coyote_timer = 0 
	if Input.is_action_just_released("jump") and velocity.y * gravity_direction < 0:
		velocity.y *= 0.5

func handle_horizontal_movement(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction  * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta * 10)
