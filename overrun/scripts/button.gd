extends Node2D

signal pressed
signal released

var is_pressed: bool = false

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D  

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)  
	area.body_exited.connect(_on_body_exited)  

func _play_press() -> void:
	anim.play("press")

func _on_body_entered(body: Node2D) -> void:
	
	if not is_pressed:
		is_pressed = true
		pressed.emit()
		_play_press()

func _on_body_exited(body: Node2D) -> void :
	await get_tree().process_frame
	var bodies = area.get_overlapping_bodies()  
	var player_bodies = bodies.filter(func(b): return b is CharacterBody2D)
	if bodies.size() == 0 and is_pressed:
		is_pressed = false
		released.emit()
		anim.play_backwards("press")
