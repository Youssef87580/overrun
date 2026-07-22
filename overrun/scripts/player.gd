extends CharacterBody2D

@export var speed : float = 200.0
@export var maximum_jumps := 1
@export var jump_velocity  : float = -250.0
@export var gravity: float = 980.0
@export var coyote_time: float = 0.1
@export var phase_duration: float = 2.0
@export var phase_cooldown: float = 3.0
var coyote_timer: float = 0.0 
var gravity_direction: int = 1
var clone_instance: Node = null 
var is_phased: bool = false
var phase_timer:float = 0.0 
var cooldown_timer:float = 0.0 

func _physics_process(delta: float) -> void: 
	handle_phase_shift()
	handle_clone_spawn()
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

func handle_clone_spawn() -> void:
	if Input.is_action_just_pressed("spawn_clone"):
		if clone_instance == null:
			clone_instance = self.duplicate()
			clone_instance.position = position
			get_parent().add_child(clone_instance)
			clone_instance.set_physics_process(false)
			clone_instance.set_process_input(false)
			clone_instance.set_script(null)
		else:
			clone_instance.queue_free()
			clone_instance = null

func handle_phase_shift() -> void:
	if cooldown_timer > 0:
		cooldown_timer -= get_physics_process_delta_time()
	if cooldown_timer <= 0 and not is_phased and Input.is_action_just_pressed("phase_shift"):
		is_phased = true
		phase_timer = phase_duration
		modulate.a = 0.5
	if is_phased:
		phase_timer -= get_physics_process_delta_time()
		if phase_timer <= 0:
			is_phased = false 
			modulate.a = 1.0
			cooldown_timer = phase_cooldown
