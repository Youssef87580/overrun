extends Control

@onready var action_list: VBoxContainer = $Panel/VBoxContainer/ScrollContainer/ActionList

const remappables_acctions := [
	"jump",
	"move_left",
	"move_right",
	"flip_gravity",
	"spawn_clone",
	"phase_shift",
]

const action_names := {
	"jump" : "jump",
	"move_left" : "move left",
	"move_right" : "move right",
	"flip_gravity" : "flip gravity",
	"spawn_clone" : "spawn clone",
	"phase_shift" : "phase shift",
}

var is_remapping := false
var action_being_remapped: String = ""
var remap_button: Button = null

func _ready() -> void:
	create_action_list()

func create_action_list() -> void:
	for child in action_list.get_children():
		child.queue_free()

	for action in REMAPPABLE_ACTIONS:
		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var label := Label.new()
		label.text = ACTION_NAMES.get(action, action)
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		var button := Button.new()
		button.text = get_action_text(action)
		button.custom_minimum_size = Vector2(200, 40)
		button.pressed.connect(_on_remap_button_pressed.bind(button, action))
		
		row.add_child(label)
		row.add_child(button)
		action_list.add_child(row)
