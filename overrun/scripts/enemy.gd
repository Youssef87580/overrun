extends RigidBody2D

@onready var hearts : Array[AnimatedSprite2D] = [$"../../player/hud/hearts/HBoxContainer/Node2D/heart1",
$"../../player/hud/hearts/HBoxContainer/Node2D2/heart2",
$"../../player/hud/hearts/HBoxContainer/Node2D3/heart3"]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player" or body.name == "player2":
		var y_delta = position.y - body.position.y
		if y_delta > -10:
			print("destroy","yyyy")
			body.jump()
			queue_free()
		else:
			print("decrease health","yyyy")
			Gamemanager.decrease_health(hearts)
			var sign
			var direction = body.global_position.direction_to(global_position)
			if direction.x > 0:
				sign = -1
			else:
				sign = 1
			print(sign,"oooo")
			body.repel(sign)
			#body.queue_free()
