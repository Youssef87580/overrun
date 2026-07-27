extends CanvasLayer

@onready var phase_ability = $PhaseAbility

func _ready() -> void:
	var use_sprite = phase_ability.get_node("UseSprite")
	use_sprite.frame = 0
	use_sprite.pause()

func play_use() -> void:
	$PhaseAbility.play_use()

func play_recharge() -> void:
	$PhaseAbility.play_recharge()
