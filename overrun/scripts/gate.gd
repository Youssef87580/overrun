extends StaticBody2D

@onready var collisionshape = $CollisionShape2D
@onready var animatedsprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _open():
	animatedsprite.play("open")
	await get_tree().create_timer(0.5).timeout
	collisionshape.disabled = true


func _close():
	if Gamemanager.lives > 0 and is_inside_tree():
		animatedsprite.play_backwards()
		await get_tree().create_timer(0.5).timeout
		collisionshape.disabled = false
