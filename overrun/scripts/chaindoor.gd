extends StaticBody2D

@onready var collisionshape = $CollisionShape2D
@onready var animatedsprite = $AnimatedSprite2D
@onready var open = $AudioStreamPlayer2D
@onready var close = $AudioStreamPlayer2D2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _open():
	animatedsprite.play("open")
	open.play()
	close.stop()
	await get_tree().create_timer(0.5).timeout
	collisionshape.disabled = true

func _close():
	animatedsprite.play("open", -2, true)
	open.stop()
	close.play()
	await get_tree().create_timer(0.5).timeout
	collisionshape.disabled = false
