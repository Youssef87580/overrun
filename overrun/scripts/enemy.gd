extends CharacterBody2D

@onready var hearts : Array[AnimatedSprite2D ] = [$"../../player/hud/hearts/HBoxContainer/Node2D/heart1",
$"../../player/hud/hearts/HBoxContainer/Node2D2/heart2",
$"../../player/hud/hearts/HBoxContainer/Node2D3/heart3"]


var gravity = 980.0
var is_chasing = false
var speed = 120
var player
var player2
var death = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta 
	
	
	if is_chasing and !death:
		$AnimatedSprite2D.play("run")
		if player != null and player2 != null:
			var chase_direction1 = player.global_position - global_position
			chase_direction1.y = 0
			chase_direction1 = chase_direction1.normalized()
			
			var chase_direction2 = player2.global_position - global_position
			chase_direction2.y = 0
			chase_direction2 = chase_direction2.normalized()
			
			var chase_direction = chase_direction1 if chase_direction1 >= chase_direction2 else chase_direction2
			velocity.x = chase_direction.x * speed
			
			if chase_direction.x != 0:
				$AnimatedSprite2D.flip_h = chase_direction.x > 0
			
		elif player != null and player2 == null:
			var chase_direction = player.global_position - global_position
			chase_direction.y = 0
			chase_direction = chase_direction.normalized()
			
			velocity.x = chase_direction.x * speed
			
			if chase_direction.x != 0:
				$AnimatedSprite2D.flip_h = chase_direction.x > 0
			
		elif player == null and player2 != null:
			var chase_direction = player2.global_position - global_position
			chase_direction.y = 0
			chase_direction = chase_direction.normalized()
			
			velocity.x = chase_direction.x * speed
			
			if chase_direction.x != 0:
				$AnimatedSprite2D.flip_h = chase_direction.x > 0
	elif !death:
		velocity.x = 0
		$AnimatedSprite2D.play("default")
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player" or body.name == "player2":
		var y_delta = position.y - body.position.y
		print(y_delta, "yyyy")
		if y_delta > 15:
			print("destroy","yyyy")
			death = true
			body.jump()
			$AnimatedSprite2D.play("Death")
			#set_physics_process(false)
			collision_layer = 0
			collision_mask = 0
			$Area2D.collision_layer = 0
			$Area2D.collision_mask = 0
			await get_tree().create_timer(0.001).timeout
			velocity.x = 0
			velocity.y = -250
			Gamemanager.kills += 1
			await get_tree().create_timer(3).timeout
			queue_free()
			
		else:
			print("decrease health","yyyy")
			Gamemanager.decrease_health(hearts)
			var sign
			var direction = body.global_position.direction_to(global_position)
			print("yyyy", direction)
			if direction.x > 0:
				sign = -1
			else:
				sign = 1
			print(sign,"oooo")
			body.repel(sign)
			#body.queue_free()


func _on_chasing_area_body_entered(body: Node2D) -> void:
	is_chasing = true
	if body.name == "player":
		player = body
	if body.name == "player2":
		player2 = body


func _on_chasing_area_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player = null
	if body.name == "player2":
		player2 = null
	if body.name == "player" or body.name == "player2":
		if player == null or player2 == null:
			is_chasing = false
