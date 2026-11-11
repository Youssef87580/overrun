extends CharacterBody2D


var speed : float = 200.0
var maximum_jumps := 1
var jump_velocity  : float = -400.0
var gravity: float = 980.0
var coyote_time: float = 0.1
var phase_duration: float = 3.0
var phase_cooldown: float = 1.
@onready var phase_ability  = $"../../../../SubViewportContainer2/SubViewport/hud2/PhaseAbility" #$hud/PhaseAbility

var coyote_timer: float = 0.0 
var gravity_direction: int = 1
var clone_instance: Node = null 
var is_phased: bool = false
var phase_timer :float = 0.0 
var phase_cooldown_timer :float = 0.0 
var repel_timer = 0
var repel_duration = 0.3


func _physics_process(delta: float) -> void: 
	handle_phase_shift()
	handle_clone_spawn()
	handle_gravity_flip()
	up_direction = Vector2(0, -gravity_direction)
	apply_gravity(delta)
	handle_jump(delta)
	if repel_timer > 0:
		repel_timer -= delta
		var direction := Input.get_axis("move_left2", "move_right2")
		velocity.x += direction * speed * 2.0 * delta
	else:
		handle_horizontal_movement(delta)
	move_and_slide()
	
	print("P2 | Velocity Y: ", velocity.y, " | Gravity: ", gravity, " | Jump: ", jump_velocity)

func handle_gravity_flip() -> void:
	if Input.is_action_just_pressed("flip_gravity2") and $Timer.time_left == 0:
		gravity_direction *= -1
		toggle_vertical_flip()
		$"../../../../SubViewportContainer2/SubViewport/hud2/flip/useflip".play("flip")
		$Timer.start()
	
func toggle_vertical_flip() -> void:
	$AnimatedSprite2D.flip_v = !$AnimatedSprite2D.flip_v

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * gravity_direction * delta 
	#else:
		#velocity.y = 0

func handle_jump(delta: float) -> void:
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer = max(coyote_timer - get_physics_process_delta_time(), 0.0)
	if Input.is_action_just_pressed("jump2") and (is_on_floor() or coyote_timer > 0) :
		velocity.y = jump_velocity * gravity_direction
		coyote_timer = 0 
	if Input.is_action_just_released("jump2") and velocity.y * gravity_direction < 0:
		velocity.y *= 0.5

func handle_horizontal_movement(delta: float) -> void:
	var direction := Input.get_axis("move_left2", "move_right2")
	if direction:
		velocity.x = direction  * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta * 10)

func handle_clone_spawn() -> void:
	if Input.is_action_just_pressed("spawn_clone2"):
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
	if phase_cooldown_timer > 0:
		phase_cooldown_timer -= get_physics_process_delta_time()
		if phase_cooldown_timer < 0:
			phase_cooldown_timer = 0.0
			
		var progress := 1.0 - (phase_cooldown_timer / phase_cooldown)
		phase_ability.set_recharge_progress(progress)
		
	elif not is_phased:
		phase_ability.set_recharge_progress(1.0)
		phase_cooldown_timer = 0.0
		
		
	if phase_cooldown_timer <= 0 and not is_phased and Input.is_action_just_pressed("phase_shift2"):
		is_phased = true
		phase_timer = phase_duration
		modulate.a = 0.5
		phase_ability.play_use()
		
	if is_phased:
		phase_timer -= get_physics_process_delta_time()
		
		if not phase_ability.use_sprite.is_playing():
			phase_ability.hold_use_frame()
		
		if phase_timer <= 0:
			is_phased = false 
			modulate.a = 1.0
			phase_cooldown_timer = phase_cooldown
			phase_ability.play_recharge()

func jump():
	velocity.y = jump_velocity * 0.5 * gravity_direction
func repel(sign):
	velocity.x = 200 * sign
	velocity.y = jump_velocity * 0.5 * gravity_direction
	repel_timer = repel_duration
