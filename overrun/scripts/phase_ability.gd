extends Node2D

@onready var use_sprite: AnimatedSprite2D = $UseSprite
@onready var recharge_sprite: AnimatedSprite2D = $RechargeSprite

func _ready() -> void:
	use_sprite.visible = false 
	recharge_sprite.visible = true
	set_recharge_progress(1.0) 

func play_use() -> void:
	recharge_sprite.visible = false
	use_sprite.visible = true
	use_sprite.frame = 0
	use_sprite.play("use")

func hold_use_frame() -> void:
	if use_sprite.is_playing():
		use_sprite.pause()
		use_sprite.frame = use_sprite.sprite_frames.get_frame_count("use") - 1

func play_recharge() -> void:
	use_sprite.visible = false
	recharge_sprite.visible = true
	recharge_sprite.frame = 0
	recharge_sprite.play("recharge")
	recharge_sprite.pause()

func set_recharge_progress(progress: float) -> void:
	var frame_count := recharge_sprite.sprite_frames.get_frame_count("recharge")
	if frame_count <= 1:
		recharge_sprite.frame = 0 
		return
	progress = clampf(progress, 0.0, 1.0)
	var target_frame : int
	if progress >= 1.0:
		target_frame = frame_count - 1
		recharge_sprite.frame = target_frame
	else:
		target_frame = clampi(int(progress * (frame_count - 	1)), 0, frame_count - 2)
		recharge_sprite.frame = target_frame 


func hide_all() -> void:
	use_sprite.visible = false
	recharge_sprite.visible = false
