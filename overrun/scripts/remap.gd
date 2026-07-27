extends Control

@onready var action_list: VBoxContainer = $Panel/VBoxContainer/ScrollContainer/ActionList

const REMAPPABLE_ACTIONS := [\

	"jump",
	"move_left",
	"move_right",
	"flip_gravity",
	"spawn_clone",
	"phase_shift",
]

const ACTION_NAMES := {
	
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
	load_bindings()
	create_action_list()
	load_bindings()
	create_action_list()
	$Panel/VBoxContainer/HBoxContainer/Return.pressed.connect(_on_Return_pressed)
	$Panel/VBoxContainer/HBoxContainer/Reset.pressed.connect(_on_Reset_pressed)

func create_action_list() -> void:
	for child in action_list.get_children():
		child.queue_free()
		
	var pixel_font = preload("res://fonts/PressStart2P-Regular.ttf")
		
	for action in REMAPPABLE_ACTIONS:
		var row := HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var label := Label.new()
		label.text = ACTION_NAMES.get(action, action)
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_override("font", pixel_font)
		
		var button := Button.new()
		button.text = get_action_text(action)
		button.custom_minimum_size = Vector2(200, 40)
		button.set_meta("action", action)
		button.pressed.connect(_on_remap_button_pressed.bind(button, action))
		button.add_theme_font_override("font", pixel_font)
		
		row.add_child(label)
		row.add_child(button)
		action_list.add_child(row)

func get_action_text(action: String) -> String:
	var events := InputMap.action_get_events(action)
	if events.is_empty():
		return "None"
	var event := events[0]
	
	if event is InputEventKey:
		return event.as_text_physical_keycode()
	
	elif  event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT: return "LMB"
			MOUSE_BUTTON_RIGHT: return "RMB"
			MOUSE_BUTTON_MIDDLE: return "MMB"
			_: return "mouse %d" % event.button_index
			
	elif event is InputEventJoypadButton:
		return "pad %d" % event.button_index
		
	return "unknown"

func _on_remap_button_pressed(button: Button, action: String) -> void:
	if is_remapping:
		return
	is_remapping = true
	action_being_remapped = action
	remap_button = button
	button.text = "press an key..."
	button.grab_focus()

func _input(event: InputEvent) -> void:
	if not is_remapping:
		return
	
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		return
	
	if not event.is_pressed():
		return
	
	if event is InputEventKey and event.keycode == KEY_ESCAPE:
		cancel_remapping()
		return
	
	for action in REMAPPABLE_ACTIONS:
		if action == action_being_remapped:
			continue
		for existing in InputMap.action_get_events(action):
			if event.is_match(existing):
				cancel_remapping()
				return
	
	apply_remap(action_being_remapped, event)
	cancel_remapping() 
	get_viewport().set_input_as_handled()

func apply_remap(action: String, event: InputEvent) -> void:
	var old_events := InputMap.action_get_events(action)
	for old in old_events:
		if old is InputEventKey or old is InputEventMouseButton:
			InputMap.action_erase_event(action, old)  
	InputMap.action_add_event(action, event)
	if remap_button:
		remap_button.text = get_action_text(action)
	save_bindings()

func cancel_remapping() -> void:
	is_remapping = false
	action_being_remapped = ""
	if remap_button:
		remap_button.text = get_action_text(remap_button.get_meta("action", ""))
		remap_button = null

func save_bindings() -> void:
	var config := ConfigFile.new()
	for action in REMAPPABLE_ACTIONS:
		var events := InputMap.action_get_events(action)
		if not events.is_empty():
			config.set_value("input", action, events[0])
	config.save("user://keybindings.cfg")

func load_bindings() -> void:
	var config := ConfigFile.new()
	if config.load("user://keybindings.cfg") != OK:
		return
	
	for action in REMAPPABLE_ACTIONS:
		if config.has_section_key("input", action):
			var event = config.get_value("input", action)
			if event is InputEvent:
				var old_events := InputMap.action_get_events(action)
				for old in old_events:
					if old is InputEventKey or old is InputEventMouseButton:
						InputMap.action_erase_event(action, old)
				InputMap.action_add_event(action, event)

func _on_back_pressed() -> void:
	visible = false
	get_tree().paused = false 

func _on_Return_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/control.tscn")

func _on_Reset_pressed() -> void:
	var dir := DirAccess.open("user://")
	if dir and dir.file_exists("keybindings.cfg"):
		dir.remove("keybindings.cfg")
	
	for action in REMAPPABLE_ACTIONS:
		var current_events := InputMap.action_get_events(action)
		for event in current_events:
			if event is InputEventKey or event is InputEventMouseButton:
				InputMap.action_erase_event(action, event)
		
		var action_dict = ProjectSettings.get_setting("input/" + action)
		if action_dict and action_dict is Dictionary and action_dict.has("events"):
			for event in action_dict.events:
				if event is InputEventKey or event is InputEventMouseButton:
					InputMap.action_add_event(action, event)
	
	create_action_list()
